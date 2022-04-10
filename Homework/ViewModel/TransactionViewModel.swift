

import Foundation
import RxSwift
import RxRelay

class TransactionViewModel {
    
    enum LoadingStatus {
        case loadstart
        case loadEnd
        case error(errorMessage: AppError)
    }
    
    private let transactionRespository: TransactionRespository
    private let disposedBag: DisposeBag
    
    let data: Observable<TrxDTOTotal>
    private let loadingSubject = BehaviorSubject<TransactionViewModel.LoadingStatus>(value: .loadstart)
    private let dataSubject = BehaviorSubject<TrxDTOTotal>(value: TrxDTOTotal())
    
    
    init(_ transactionRespository: TransactionRespository,
         _ disposedBag: DisposeBag) {
        data = dataSubject.asObservable()
        self.transactionRespository = transactionRespository
        self.disposedBag = disposedBag
    }
    
    func readUserData() -> BehaviorSubject<TransactionViewModel.LoadingStatus> {
        
        loadingSubject.onNext(.loadstart)
        transactionRespository
            .dataResult()
            .subscribe(onSuccess: { [weak self] status in
                switch status {
                    
                case .data(let datas):
                    self?.dataSubject.onNext(datas)
                case .error(let error):
                    self?.loadingSubject.onNext(.error(errorMessage: error))
                }
                self?.loadingSubject.onNext(.loadEnd)
            }, onFailure: { [weak self] error in
                self?.loadingSubject.onNext(.error(errorMessage: AppError.init(error)))
                self?.loadingSubject.onNext(.loadEnd)
                
            }).disposed(by: disposedBag)
        
        return loadingSubject
    }
}
