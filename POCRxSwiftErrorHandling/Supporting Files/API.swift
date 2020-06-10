//
//  API.swift
//  POCRxSwiftErrorHandling
//
//  Created by Punde, Rasika Nanasaheb on 03/06/20.
//  Copyright © 2020 Punde, Rasika Nanasaheb (US - Mumbai). All rights reserved.
//

import Foundation
import RxSwift
import SwiftyJSON

enum ErrorType: Error {
    case internalError(String)
    case serverError(String)
    case connectionError(String)
    case authorizationError(String)
    case tooManyAttempts
}

enum Result<Value> {
    case Success(Value)
    case Failure(ErrorType)
}

class ViewModel {
    func getAllTracks() -> Observable<Result<[Album]>> {
        return Observable.create { (observer) -> Disposable in
            ServiceManager.requestData(url: "dcd86ebedb5e519fd7b09b79dd4e4558/raw/b7505a54339f965413f5d9feb05b67fb7d0e464e/MvvmExampleApi.json", method: .get, parameters: nil, completion: { (result) in
                switch result {
                case .success(let returnJson) :
                    let albums = returnJson["Albums"].arrayValue.compactMap {return Album(data: try! $0.rawData())}
                    return observer.onNext(.Success(albums))
                case .failure(let failure) :
                    switch failure {
                    case .connectionError:
                        return observer.onNext(.Failure(.connectionError("Check your Internet connection.")))
                    case .authorizationError(let errorJson):
                        return observer.onNext(.Failure(.serverError(errorJson["message"].stringValue)))
                    default:
//                        return observer.onNext(.Failure(.internalError("Unknown Error")))
                        return observer.onError(ErrorType.tooManyAttempts)
                    }
                }
            })

            return Disposables.create()
        }
    }

    func xyz() -> Observable<Result<[Album]>> {


        let dispatchQueue = DispatchQueue(label: "com.abc.images.queue", qos: DispatchQoS.userInteractive, attributes: [.concurrent])
        let customScheduler = ConcurrentDispatchQueueScheduler(queue: dispatchQueue)

        func getToken(_ old: String) -> Observable<(response: HTTPURLResponse, data: Data)> {
            let response = HTTPURLResponse(url: URL(fileURLWithPath: "https://....."), statusCode: 200, httpVersion: nil, headerFields: nil)!
            let data = "second".data(using: .utf8)!
            return Observable.just((response: response, data: data)).delay(.seconds(20), scheduler: MainScheduler.instance)
        }

        func extractToken(_ data: Data) -> String {
            return String(data: data, encoding: .utf8) ?? ""
        }

        let tokenAcquisitionService = TokenAcquisitionService.init(initialToken: "", getToken: getToken, extractToken: extractToken(_:))

        return Observable.deferred { tokenAcquisitionService.token.take(1) }
        .flatMap { token -> Observable<Result<[Album]>> in
            // you need to insert the current token into the headers below.
            self.getAllTracks()
                .catchError { error in
                    // you need some way to know if the error was because of an unauthorized attempt (401)
                    throw TokenAcquisitionError.unauthorized
//                    if error {
//                        throw TokenAcquisitionError.unauthorized
//                    } else {
//                        throw error
//                    }
            }
        }
        .observeOn(customScheduler)
        .retryWhen { $0.renewToken(with: tokenAcquisitionService) }
    }

    func customeScheduler() {
        // Define own custom queue
        let customQueue = SerialDispatchQueueScheduler(internalSerialQueueName: "")
        let dispatchQueue = DispatchQueue(label: "com.abc.images.queue", qos: DispatchQoS.userInteractive, attributes: [.concurrent])

        let operationQueue = OperationQueue()

        let operationScheduler = OperationQueueScheduler.init(operationQueue: operationQueue, queuePriority: .high)
    }
}
