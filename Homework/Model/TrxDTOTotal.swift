
import Foundation
import RxDataSources

struct TrxDTOTotal {

    
    private(set) var total: Int
    private(set) var trxDto: [TrxDTO]
    
    init(data: [TrxDTO]) {
        var tmpvalue = 0
        self.trxDto = data
        
        for item in data {
            
            for detail in item.details {
                tmpvalue += detail.total
            }
        }
        
        self.total = tmpvalue
    }
    
    init() {
        self.total = 0
        self.trxDto = []
    }
}


struct TrxDTO {
    private(set) var id: Int
    private(set) var time: String
    private(set) var title: String
    private(set) var description: String
    private(set) var details: [TrxDTODetail]
    
    init(data: DataResponse) {
        self.id = data.id
        let time = TimeInterval(data.time)
        let date = Date(timeIntervalSince1970: time)
        let formattar = DateFormatter()
        formattar.dateFormat = "yyyy-MM-dd"
        self.time = formattar.string(from: date)
        self.title = data.title
        self.description = data.description
        
        if let detail = data.details {
            self.details = []
            for item in detail {
                self.details.append(TrxDTODetail(data: item))
            }
        } else {
            self.details = []
        }
    }
}
extension TrxDTO: SectionModelType {
    var items: [TrxDTODetail] {
        return details
    }
    
    init(original: TrxDTO, items: [TrxDTODetail]) {
        self = original
        self.details = items
    }
    
    typealias Item = TrxDTODetail
    
    
}

struct TrxDTODetail {
    private(set) var name: String
    private(set) var price: Int
    private(set) var quantity: Int
    private(set) var total: Int
    
    init(data: DetailResponse) {
        self.name = data.name
        self.price = data.price
        self.quantity = data.quantity
        self.total = data.price * data.quantity
    }
}
