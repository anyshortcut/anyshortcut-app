//
// Created by Dylan Wang on 2020/3/20.
// Copyright © 2020 anyshortcut. all rights reserved.
// 

import Foundation

public protocol Storage: Codable {
    static var fileName: String { get }
}

public extension Storage {

    /// Save to disk
    func persist() throws {
        let path = (storageDirectory as NSString).appendingPathComponent(Self.fileName)
        let data = try JSONEncoder().encode(self)
        do {
            try data.write(to: URL(fileURLWithPath: path))
            print("\(Self.self): saved to \(path)")
        } catch {
            print("\(Self.self): save failed", "error: \(error)")
            throw error
        }
    }

    /// Parse from disk
    static func parse() throws -> Self {
        let path = (storageDirectory as NSString).appendingPathComponent(fileName)
        let data = try Data(contentsOf: URL(fileURLWithPath: path))
        return try JSONDecoder().decode(Self.self, from: data)
    }

    static func clear() throws {
        let path = (storageDirectory as NSString).appendingPathComponent(Self.fileName)
        if FileManager.default.fileExists(atPath: path) {
            try FileManager.default.removeItem(atPath: path)
        }
    }
}

/// Storage directory
let storageDirectory: String = {
    let appName = Bundle.main.infoDictionary![kCFBundleNameKey as String] as! String
    let path = (NSSearchPathForDirectoriesInDomains(.applicationSupportDirectory, .userDomainMask, true).first! as NSString).appendingPathComponent(appName)
    if !FileManager.default.fileExists(atPath: path) {
        _ = try? FileManager.default.createDirectory(atPath: path, withIntermediateDirectories: true, attributes: nil)
    }
    return path
}()
