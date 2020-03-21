//
// Created by Dylan Wang on 2020/3/21.
// Copyright © 2020 anyshortcut. all rights reserved.
// 

import Foundation
import Siesta

let apiClient = APIClient(environment: .production)

struct Response {
    let code: Int
    let message: String
    let data: Data?

    init(json: [String: Any]) {
        self.code = json["code"] as? Int ?? -1
        self.message = json["message"] as? String ?? ""
        self.data = json["data"] as? Data
    }
}

final class APIClient {

    private let environment: Environment
    private let service: Service

    init(environment: Environment) {
        self.environment = environment
        self.service = Service(baseURL: environment.baseURL)
        configureService()
    }

    private func configureService() {
        service.configureTransformer("**", atStage: .model) {
            Response(json: $0.content)
        }
    }

    private lazy var loginResource: Resource = { service.resource(environment.loginPath) }()

}

extension APIClient {

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
                    if let data = response.data {
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
