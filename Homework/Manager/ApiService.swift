//
//  ApiService.swift
//  Homework
//
//  Created by Shirley on 2022/4/2.
//

import Foundation
import RxSwift

protocol IApiservice {
    func callProductApi(url: String) -> Single<HttpStatus<[DataResponse]>>
    func callInserDataApi(url: String, parameter: InsertTransationParameter) -> Single<HttpStatus<Data>>
}

extension IApiservice {
    func callProductApi(url: String) -> Single<HttpStatus<[DataResponse]>> {
        fatalError("Not Implemented")
    }
    func callInserDataApi(url: String, parameter: InsertTransationParameter) -> Single<HttpStatus<Data>> {
        fatalError("Not Implemented")
    }    
}

struct ApiService: IApiservice {
    
    var httpRequest: HttpRequest {
        return HttpRequest.Singleton
    }
    
    func callProductApi(url: String) -> Single<HttpStatus<[DataResponse]>> {
        httpRequest.decodeApiResult(url: url)
    }
    
    func callInserDataApi(url: String, parameter: InsertTransationParameter) -> Single<HttpStatus<Data>> {
        httpRequest.post(url: url, parameter: parameter)
    }
}
