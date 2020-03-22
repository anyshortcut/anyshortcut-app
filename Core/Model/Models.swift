//
// Created by Dylan Wang on 2020/3/20.
// Copyright © 2020 anyshortcut. all rights reserved.
// 

import Foundation

public struct Shortcut: Codable {

    public typealias Key = String
    public typealias Domain = String

    public let id: UInt
    public let key: Key
    public let url: URL
    public let title: String
    public let comment: String?
    public let domain: Domain
    public let openTimes: Int
    public let createdTime: Date
    public let favicon: String?

}

public typealias PrimaryShortcutArray = [Shortcut]
public typealias SecondaryShortcutDictionary = [Shortcut.Domain: [Shortcut]]

public struct ShortcutStorage: Storage {

    public static var fileName: String { return "anyshortcut.json" }

    let primary: PrimaryShortcutArray
    let secondary: SecondaryShortcutDictionary
}

public struct Meta: Storage {

    public static var fileName: String { return "meta.json" }

    public let token: String

    public init(token: String) {
        self.token = token
    }
}
