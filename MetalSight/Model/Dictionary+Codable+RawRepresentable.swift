//
// Dictionary+Codable+RawRepresentable.swift
// MetalSight
//
// Created by Barreloofy on 12/15/25 at 8:41 PM
//

import Foundation

extension Dictionary: @retroactive RawRepresentable where Key: Codable, Value: Codable {
  public typealias RawValue = String

  public init?(rawValue: String) {
    guard
      let data = rawValue.data(using: .utf8),
      let value = try? JSONDecoder().decode(Self.self, from: data)
    else { return nil }

    self = value
  }

  public var rawValue: String {
    guard
      let data = try? JSONEncoder().encode(self),
      let value = String(data: data, encoding: .utf8)
    else { return "[:]" }

    return value
  }
}
