import UIKit

class Block {
    
    var hash: String!
    var data: String!
    var previousHash: String!
    var index: Int!
    
    func generateHash() -> String {
        //to decide if transaction will be genesis or normal
        //This function generates a UUID, erases any hyphens, and returns the String
        return NSUUID().uuidString.replacingOccurrences(of: "-", with: "")
    }
}
