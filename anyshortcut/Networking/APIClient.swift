//
// Created by Dylan Wang on 2020/3/21.
// Copyright © 2020 anyshortcut. all rights reserved.
// 

import Foundation
import Siesta

let apiClient = APIClient(environment: .production)

public struct Response {
    let code: Int
    let message: String
    let data: JSONConvertible?

    init(json: [String: Any]) {
        self.code = json["code"] as? Int ?? -1
        self.message = json["message"] as? String ?? ""
        self.data = json["data"] as? JSONConvertible
    }
}

public final class APIClient {

    private let environment: Environment
    private let service: Service

    init(environment: Environment) {
        self.environment = environment
        self.service = Service(baseURL: environment.baseURL)
        configureService()
    }

    private func configureService() {
        #if DEBUG
        LogCategory.enabled = [.network, .pipeline, .observers]
        #endif
        service.configureTransformer("**", atStage: .model) {
            Response(json: $0.content)
        }
    }

    private lazy var loginResource: Resource = { service.resource(environment.loginPath) }()
    private lazy var allShortcutsResource: Resource = { service.resource(environment.allShortcutsPath) }()

}

public extension APIClient {

    func login(with accessToken: String, completion: @escaping (Result<Meta?, APIError>) -> Void) {
        if accessToken.isEmpty {
            completion(.failure(.invalidToken))
            return
        }
        let resource = loginResource
            .withParam("access_token", accessToken)
            .addObserver(owner: self) { [weak self] (resource, event) in
                self?.process(resource, event: event, with: completion)
        }
        resource.load()
    }

    func getAllShortcuts(completion: @escaping (Result<ShortcutStorage?, APIError>) -> Void) {
        do {
            let accessToken = try Meta.parse().token
            let resource = allShortcutsResource
                .withParam("access_token", accessToken)
                .withParam("nested", "false")
                .addObserver(owner: self) { [weak self] (resource, event) in
                    self?.process(resource, event: event, with: completion)
            }
            resource.load()
        } catch {
            completion(.failure(.accessTokenRequired))
        }
    }
}

// MARK: - API results processing

private extension APIClient {

    func process<M: Decodable>(_ resource: Resource, event: ResourceEvent, with completion: @escaping (Result<M?, APIError>) -> Void) {
        switch event {
        case .error:
            completion(.failure(resource.error))
        case .newData:
            guard let response: Response = resource.typedContent() else {
                completion(.failure(.adapter))
                return
            }

            switch response.code {
            case 200:
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                do {
                    if let json = response.data {
                        let data = try JSONSerialization.data(withJSONObject: json, options: [])
                        let result = try decoder.decode(M.self, from: data)
                        completion(.success(result))
                    } else {
                        completion(.success(nil))
                    }
                } catch {
                    completion(.failure(.adapter))
                }
            case 1000:
                completion(.failure(.accessTokenRequired))
            case 1001, 1002:
                completion(.failure(.invalidToken))
            default:
                completion(.failure(.unknown))
            }


        default: break
        }
    }

}
