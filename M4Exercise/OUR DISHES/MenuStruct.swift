import Foundation

struct JSONMenu: Codable {
    // add code here
    let menu : [MenuItem]
}


struct MenuItem: Codable, Identifiable {
    let id = UUID()
    
    // add code here
    let title : String
    let price : String
}


