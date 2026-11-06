public import BlogModule
public import FeatherModuleKit
import WebModule

extension BlogModule.Settings.Detail {
    public struct Scope: FeatherModuleKit.Scope {
        public let settings: any Query.Interface

        public init(settings: any Query.Interface) {
            self.settings = settings
        }
    }
}
