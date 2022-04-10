
import Foundation

public struct DataResponse: Decodable {
    private(set) var id: Int
    private(set) var time: Int
    private(set) var title: String
    private(set) var description: String
    private(set) var details: [DetailResponse]?
    
}

struct DetailResponse: Decodable {
    
    private(set) var name: String
    private(set) var quantity: Int
    private(set) var price: Int
    
}
