public import FeatherModuleKit
public import WebDomain
public import WebModule

extension Page.Add {
    public struct Scope: FeatherModuleKit.Scope {
        public let page: any Page.Repository.Interface

        public init(page: any Page.Repository.Interface) {
            self.page = page
        }
    }
}
