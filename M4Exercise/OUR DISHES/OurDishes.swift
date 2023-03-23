import SwiftUI
import CoreData

struct OurDishes: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @ObservedObject var dishesModel = DishesModel()
    @State private var showAlert = false
    @State var searchText = ""
    @State var sortByPrice = false
    
    
    var body: some View {
        VStack {
            LittleLemonLogo()
                .padding(.bottom, 10)
                .padding(.top, 50)
            
            Text ("Tap to order")
                .foregroundColor(.black)
                .padding([.leading, .trailing], 40)
                .padding([.top, .bottom], 8)
                .background(Color("approvedYellow"))
                .cornerRadius(20)
            
            
            NavigationView {
                FetchedObjects(
                    predicate:buildPredicate(),
                    sortDescriptors: buildSortDescriptors()) {
                        (dishes: [Dish]) in
                        List {
                            // Code for the list enumeration here
                            ForEach(dishes , id:\.self) {dish in
                                DisplayDish(dish)
                               // Text("id")
                                    .onTapGesture {
                                    showAlert.toggle()
                                }
                                
                            }
                        }
                        // add the search bar modifier here
                        .searchable(text: $searchText,
                                     prompt: "search...")
                      
                    }
            }
            
            // SwiftUI has this space between the title and the list
            // that is amost impossible to remove without incurring
            // into complex steps that run out of the scope of this
            // course, so, this is a hack, to bring the list up
            // try to comment this line and see what happens.
            .padding(.top, -10)//
            
            .alert("Order placed, thanks!",
                   isPresented: $showAlert) {
                Button("OK", role: .cancel) { }
            }
            
            // makes the list background invisible, default is gray
                   .scrollContentBackground(.hidden)
            
            // runs when the view appears
                   .task {
                      
                       await dishesModel.reload(viewContext)
                       if dishesModel.menuItems.count > 0 {
                           print("\(dishesModel.menuItems[2].title )")
                       }
                           
                   }
            
        }
    }
    
    
    
    func buildPredicate() -> NSPredicate {
        return searchText == "" ? NSPredicate(value: true) : NSPredicate(format: "name CONTAINS[cd] %@", searchText)
    }
    
    
    func buildSortDescriptors () -> [NSSortDescriptor] {
        return [
            NSSortDescriptor(key: sortByPrice ? "price" : "name",
                             ascending: true,
                             selector:
                                #selector(NSString .localizedCaseInsensitiveCompare))
            
        ]
    }
}

struct OurDishes_Previews: PreviewProvider {
    static var previews: some View {
        OurDishes()
    }
}






