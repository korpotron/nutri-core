import Foundation

public struct Mineral {
    let name: String

    package init(_ name: String) {
        self.name = name
    }
}

extension Mineral: Sendable {}

extension Mineral: Hashable {}

extension Mineral: CustomStringConvertible {
    public var description: String {
        "mineral:\(name)"
    }
}

extension Mineral: Identifiable {
    public var id: String {
        name
    }
}
