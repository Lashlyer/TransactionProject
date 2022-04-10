
import Foundation
import RxSwift

class TransactionRespository {
    
    enum DataResultType {
        case data(_ data: TrxDTOTotal)
        case error(_ error: AppError)
    }

    private let apiService: IApiservice
    
    init(_ apiserivce: IApiservice) {
        self.apiService = apiserivce
    }
    
    public func dataResult() -> Single<DataResultType> {
        apiService.callProductApi(url: HttpUrl.host + HttpUrl.transaction).flatMap { [weak self] status in
            
            switch status {
                
            case .data(let data):
                return .just(.data(self?.sortAndCalculate(data: data) ?? TrxDTOTotal()))
            case .error(let error):
                return .just(.error(error))
            }
        }.observe(on: MainScheduler.instance)
        
    }
    
    private func sortAndCalculate(data: [DataResponse]) -> TrxDTOTotal {
        var trxDto: [TrxDTO] = []
        
        let sortData = data.sorted(by: { $0.time > $1.time })
        
        for item in sortData {
            trxDto.append(TrxDTO(data: item))
        }
        
        return TrxDTOTotal(data: trxDto)
        
    }
}

