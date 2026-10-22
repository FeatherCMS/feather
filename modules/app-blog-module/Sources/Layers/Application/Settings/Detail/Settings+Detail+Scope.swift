public import BlogDomain
public import BlogModule
public import FeatherModuleKit
import WebModule

extension BlogModule.Settings.Detail {
    public struct Scope: FeatherModuleKit.Scope {
        public let settings: any BlogModule.Settings.Repository.Interface

        public init(settings: any BlogModule.Settings.Repository.Interface) {
            self.settings = settings
        }
    }
}
