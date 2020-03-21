//
// Created by Dylan Wang on 2020/3/21.
// Copyright © 2020 anyshortcut. all rights reserved.
// 

import Foundation

struct Environment {
    let baseURL: String
    let loginPath: String = "/user/login"
    let allShortcutsPath: String = "/shortcuts/all"
}

extension Environment {
    static let production = Environment(baseURL: "https://api.anyshortcut.com")
}
