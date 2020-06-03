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

enum ErrorType {
    case internalError(String)
    case serverError(String)
    case connectionError(String)
    case authorizationError(String)
}

enum Result<Value> {
    case Success(Value)
    case Failure(ErrorType)
}

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
                    return observer.onNext(.Failure(.internalError("Unknown Error")))
                }
            }
        })

        return Disposables.create()
    }
}
