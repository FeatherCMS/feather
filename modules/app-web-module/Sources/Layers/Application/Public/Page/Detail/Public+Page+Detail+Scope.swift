public import FeatherModuleKit
public import WebModule

extension Public.Page.Detail {
    public struct Scope: FeatherModuleKit.Scope {
        public let page: any Page.Detail.Query.Interface

        public init(page: any Page.Detail.Query.Interface) {
            self.page = page
        }
    }
}
