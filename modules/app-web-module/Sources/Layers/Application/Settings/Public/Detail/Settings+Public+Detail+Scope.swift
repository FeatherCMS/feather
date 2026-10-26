public import FeatherModuleKit
public import WebModule

extension Settings.Public.Detail {
    public struct Scope: FeatherModuleKit.Scope {
        public let settings: any Query.Interface

        public init(settings: any Query.Interface) {
            self.settings = settings
        }
    }
}
