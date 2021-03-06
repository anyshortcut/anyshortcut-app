//
// Created by Dylan Wang on 2020/3/21.
// Copyright © 2020 anyshortcut. all rights reserved.
// 

import Foundation
import Siesta

public enum APIError: Error, CustomNSError {
    case http(Error)
    case adapter
    case accessTokenRequired
    case invalidToken
    case unknown

    public var localizedDescription: String {
        switch self {
        case let .http(error as RequestError):
            return error.userMessage
        case let .http(error):
            return error.localizedDescription
        case .adapter:
            return "Unable to process the data returned by the server"
        case .accessTokenRequired:
            return "Access token required"
        case .invalidToken:
            return "Invalid access token"
        case .unknown:
            return "An unknown error occurred"
        }
    }

    public static var errorDomain: String {
        return "com.anyshortcut.error"
    }

    public var errorCode: Int {
        switch self {
        case .http: return 0
        case .adapter: return 1
        case .accessTokenRequired: return 1000
        case .invalidToken: return 1002
        case .unknown: return -1
        }
    }

    /// The user-info dictionary.
    public var errorUserInfo: [String: Any] {
        var userInfo = [NSLocalizedDescriptionKey: localizedDescription]

        if case let .http(underlying as RequestError) = self, let urlError = underlying.cause as? URLError {
            let underlyingUserInfo = urlError.errorUserInfo.compactMapValues { $0 as? String }
            userInfo.merge(underlyingUserInfo, uniquingKeysWith: { $1 })
            userInfo[NSLocalizedRecoverySuggestionErrorKey] = "Please try again"
        } else if case let .http(underlying as RequestError) = self, underlying.cause is DecodingError {
            userInfo[NSLocalizedRecoverySuggestionErrorKey] = "Please report this error"
        }

        return userInfo
    }
}

extension Resource {

    var error: APIError {
        if let underlyingError = latestError {
            return .http(underlyingError)
        } else {
            return .unknown
        }
    }

}
