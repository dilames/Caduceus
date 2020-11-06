//
//  MoyaProvider+FetchDecodable.swift
//  Platform
//
//  Created by Andrew Chersky  on 2/20/18.
//

import Foundation
import Moya
import ReactiveSwift
import Result

typealias MoyaProviderCompletion<T: Decodable> = (Result<T, AnyError>) -> Void
typealias MoyaProviderSuccessCompletion = (Result<Void, AnyError>) -> Void

extension MoyaProviderType {
    func fetchRequest<T: Decodable>(_ target: Target, completion: @escaping MoyaProviderCompletion<T>) -> Moya.Cancellable {
        return request(target, callbackQueue: nil, progress: nil, completion: { result in
            switch result {
            case .success(let response):
                do {
                    try self.validate(response)
                    let value = try JSONDecoder().decode(T.self, from: response.data)
                    completion(.success(value))
                } catch {
                    completion(.failure(.init(error)))
                }
            case .failure(let error):
                completion(.failure(.init(error)))
            }
        })
    }
    
    func successRequest(_ target: Target, completion: @escaping MoyaProviderSuccessCompletion) -> Moya.Cancellable {
        return request(target, callbackQueue: nil, progress: nil, completion: { result in
            switch result {
            case .success(let response):
                do {
                    try self.validate(response)
                    completion(.success(()))
                } catch {
                    completion(.failure(.init(error)))
                }                
            case .failure(let error):
                completion(.failure(.init(error)))
            }
        })
    }
    
    private func validate(_ response: Response) throws {
        guard 400 ..< 600 ~= response.statusCode else {
            return
        }
        do {
			let apiError = try JSONDecoder().decode(ApiError.self, from: response.data)
            throw apiError
        } catch {
			throw error
        }
    }
}

extension Reactive where Base: MoyaProviderType {
    func fetchRequest<T: Decodable>(_ target: Base.Target) -> SignalProducer<T, AnyError> {
        return SignalProducer { observer, lifetime in
            let cancellable = self.base.fetchRequest(target, completion: { (result: Result<T, AnyError>) in
                switch result {
                case .success(let value):
                    observer.send(value: value)
                    observer.sendCompleted()
                case .failure(let error):
                    observer.send(error: error)
                }
            })
            lifetime.observeEnded {
                cancellable.cancel()
            }
        }
    }
    
    func successRequest(_ target: Base.Target) -> SignalProducer<Void, AnyError> {
        return SignalProducer { observer, lifetime in
            let cancellable = self.base.successRequest(target, completion: { (result: Result<Void, AnyError>) in
                switch result {
                case .success:
                    observer.send(value: ())
                    observer.sendCompleted()
                case .failure(let error):
                    observer.send(error: error)
                }
            })
            lifetime.observeEnded {
                cancellable.cancel()
            }
        }
    }
}
