public import FeatherModuleKit
public import WebDomain

extension Settings.Edit {
    public struct Scope: FeatherModuleKit.Scope {
        public let settings: any Settings.Repository.Interface

        public init(settings: any Settings.Repository.Interface) {
            self.settings = settings
        }
    }
}
