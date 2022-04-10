
import Foundation
import Alamofire
import RxSwift

public class HttpUrl {
    
    static let host: String = "https://e-app-testing-z.herokuapp.com"
    static let transaction: String = "/transaction"
    
}


public class HttpRequest {
    
    public static let Singleton = HttpRequest()
    
    public func get(url: String) -> Single<HttpStatus<Data>> {
        Single<HttpStatus<Data>>.create { closure in
            let request = AF.request(url, method: .get)
            request.response(queue: .global()) { response in
                switch response.result {
                    
                case .success(let data):
                    if let datas = data {
                        closure(.success(.data(datas)))
                    } else {
                        closure(.failure(AppError("App data == nil")))
                    }
                case .failure(let error):
                    closure(.failure(AppError(error)))
                }
            }
            return Disposables.create {
                request.cancel()
            }
        }
    }
    
    public func post(url: String, parameter: InsertTransationParameter) -> Single<HttpStatus<Data>> {

        Single<HttpStatus<Data>>.create { closure in
            let request = AF.request(url,
                                     method: .post,
                                     parameters: parameter,
                                     encoder: JSONParameterEncoder.default).response(queue:.global()) {
                response in
                switch response.result {
                case .success(let data):
                    if let datas = data {
                        closure(.success(.data(datas)))
                    } else {
                        closure(.failure(AppError("http data == nil")))
                    }
                case .failure(let error):
                    closure(.failure(AppError(error)))
                }
            }
            return Disposables.create {
                request.cancel()
            }
        }
    }
    
    public func decodeApiResult(url: String) -> Single<HttpStatus<[DataResponse]>> {
        get(url: url).flatMap { status -> Single<HttpStatus<[DataResponse]>> in
            switch status {
            case .data(let d):
                do {
                    let result = try ResultDecoder.parser(d)
                    return Single.just(.data(result))
                } catch let error as AppError {
                    return Single.just(.error(error))
                }
            case .error(let e):
                return Single.just(.error(e))
            }
        }
    }
}
