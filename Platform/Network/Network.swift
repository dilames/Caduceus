//
//  NetworkProvider.swift
//  Platform
//
//  Created by Andrew Chersky  on 2/20/18.
//

import Foundation
import Alamofire
import Moya
import Reqres
import ReactiveSwift

final class Network {
    
    private lazy var session: Session = setupSession()
    
    private func setupSession() -> Session {
        let configuration = Reqres.defaultSessionConfiguration()
        configuration.headers = .default
        let session = Session(configuration: configuration, interceptor: self)
        return session
    }
    
    func provider<T>() -> MoyaProvider<T> where T: TargetType {
        return MoyaProvider(session: session)
    }
    
    weak var accessTokenProvider: AccessTokenProvider?
}

// MARK: - RequestAdapter
extension Network: RequestInterceptor {
    
    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        completion(.success(urlRequest))
    }
    
    func retry(_ request: Request, for session: Session, dueTo error: Error, completion: @escaping (RetryResult) -> Void) {
        guard
            let error = error as? ApiError,
            error.code == 401 else {
                completion(.doNotRetry)
                return
        }
        accessTokenProvider?.refreshToken(else: error).startWithResult {
            switch $0 {
            case .success:
                completion(.retry)
            case .failure:
                completion(.doNotRetry)
            }
        }
    }
    
}
