//
//  AccessIDs.swift
//  AccessIDs
//
//  Created by Duyet Nguyen on 27/9/20.
//

import UIKit

public protocol AccessID {
  var id: String { get }
}

public extension AccessID where Self: RawRepresentable, Self.RawValue == String {
  var id: String { return rawValue }
}

extension UIView {
  public func setAccessID(_ id: String?) {
    accessibilityIdentifier = id
  }

  public func setAccessID(_ accessID: AccessID?) {
    accessibilityIdentifier = accessID?.id
  }
}

// MARK: - Access ids
public enum MainAccessID: String, AccessID {
  case tableView
  case loadingView
}
