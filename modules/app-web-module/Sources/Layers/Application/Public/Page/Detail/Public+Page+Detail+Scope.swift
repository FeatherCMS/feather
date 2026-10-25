public import FeatherModuleKit
public import WebModule

extension Public.Page.Detail {
    public struct Scope: FeatherModuleKit.Scope {
        public let page: any Query.Interface

        public init(page: any Query.Interface) {
            self.page = page
        }
    }
}
