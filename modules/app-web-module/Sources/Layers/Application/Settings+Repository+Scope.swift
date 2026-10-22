public import FeatherModuleKit
public import WebDomain

extension Settings.Repository {
    public struct Scope: FeatherModuleKit.Scope {
        public let settings: any Interface

        public init(settings: any Interface) {
            self.settings = settings
        }
    }
}
