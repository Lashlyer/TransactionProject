//
//  InserTransationRepostory.swift
//  Homework
//
//  Created by Alvin on 2022/4/8.
//

import Foundation
import RxSwift

class InserTransationRepository {
    
    
    enum InserResultType {
        case succse
        case error(_ error: AppError)
    }
    
    private let apiService: IApiservice
 
    init(_ apiservice: IApiservice) {
        
        self.apiService = apiservice
    }
    
    public func inserTransationResult(parameter: InsertTransationParameter) -> Single<InserResultType> {
        apiService.callInserDataApi(url: HttpUrl.host + HttpUrl.transaction, parameter: parameter).flatMap { status -> Single<InserResultType> in
            switch status {
                
            case .data(_):
                return .just(.succse)
            case .error(let error):
                return .just(.error(error))
            }
        }.observe(on: MainScheduler.instance)
    }
}
