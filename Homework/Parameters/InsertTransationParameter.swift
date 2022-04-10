
import Foundation

public struct InsertTransationParameter: Encodable {
    private(set) var time: Int
    private(set) var title: String
    private(set) var description: String
    private(set) var details: [DetailTransationParameter]?
    init(_ time: Int,
         _ title: String,
         _ description: String,
         _ details: [DetailTransationParameter]) {
        self.time = time
        self.title = title
        self.description = description
        self.details = details
    }

}

public struct DetailTransationParameter: Encodable {
    private(set) var name: String
    private(set) var quantity: Int
    private(set) var price: Int

    init(_ name: String,
         _ quantity: Int,
         _ price: Int) {
        self.name = name
        self.quantity = quantity
        self.price = price
    }
}
