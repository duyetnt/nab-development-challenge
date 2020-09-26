//
//  Encodable+Extensions.swift
//  NetworkStubber
//
//  Created by Duyet Nguyen on 26/9/20.
//

import Foundation

extension Encodable {
  func toData() -> Data? {
    return try? JSONEncoder().encode(self)
  }
}
