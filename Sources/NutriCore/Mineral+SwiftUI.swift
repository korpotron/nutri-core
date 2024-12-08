import SwiftUI

public extension LocalizedStringKey {
    init(_ mineral: Mineral) {
        self.init("mineral_\(mineral.name)")
    }
}

public extension LocalizedStringResource {
    init(_ mineral: Mineral) {
        self.init(String.LocalizationValue("mineral_" + mineral.name), table: "Minerals", bundle: .module)
    }
}

public extension Text {
    init(_ mineral: Mineral) {
        self.init(LocalizedStringResource(mineral))
    }
}

private extension LocalizedStringResource.BundleDescription {
    static let module = Self.atURL(Bundle.module.bundleURL)
}

private extension Mineral {
    static let example = Self("example")
}

#Preview {
    VStack {
        Text(.example)
    }
}
