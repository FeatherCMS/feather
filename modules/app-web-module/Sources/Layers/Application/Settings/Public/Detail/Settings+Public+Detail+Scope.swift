public import FeatherModuleKit
public import WebDomain
public import WebModule

extension Settings.Public.Detail {
    public struct Scope: FeatherModuleKit.Scope {
        public let settings: any Settings.Repository.Interface

        public init(settings: any Settings.Repository.Interface) {
            self.settings = settings
        }
    }
}
