public import BlogDomain
public import BlogModule
public import FeatherModuleKit

extension Settings.Detail {
    public struct Scope: FeatherModuleKit.Scope {
        public let settings: any Settings.Repository.Interface

        public init(settings: any Settings.Repository.Interface) {
            self.settings = settings
        }
    }
}
