//
//  InserTransationViewModel.swift
//  Homework
//
//  Created by Alvin on 2022/4/8.
//

import Foundation
import RxSwift

class InserTransatioViewModel {
    
    enum LoadingStatus {
        case loadstart
        case loadEnd
        case succes
        case error(errorMessage: AppError)
    }
    
    private let disposedBag: DisposeBag
    private let inserTrasationRepository: InserTransationRepository
    let dateObserverble = BehaviorSubject<String>(value: "")
    let detaildatatmpObserverble = BehaviorSubject<[DetailTransationParameter]>(value: [])
    private let intserDataSubject = BehaviorSubject<InserTransatioViewModel.LoadingStatus>(value: .loadstart)
    
    
    init(_ inserttransationrepository: InserTransationRepository,
         _ disposeBag: DisposeBag) {
        
        self.inserTrasationRepository = inserttransationrepository
        self.disposedBag = disposeBag
    }
    
    public func inserData(parameter: InsertTransationParameter) -> BehaviorSubject<InserTransatioViewModel.LoadingStatus> {
        
        self.intserDataSubject.onNext(.loadstart)
        
        inserTrasationRepository
            .inserTransationResult(parameter: parameter)
            .subscribe(onSuccess: { [weak self] status in
                switch status {
                    
                case .succse:
                    self?.intserDataSubject.onNext(.succes)
                case .error(let error):
                    self?.intserDataSubject.onNext(.error(errorMessage: error))
                }
                self?.intserDataSubject.onNext(.loadEnd)
            }, onFailure: { [weak self] error in
                self?.intserDataSubject.onNext(.error(errorMessage: AppError.init(error)))
                self?.intserDataSubject.onNext(.loadEnd)
                
            }).disposed(by: disposedBag)

        

        return intserDataSubject
    }
}
