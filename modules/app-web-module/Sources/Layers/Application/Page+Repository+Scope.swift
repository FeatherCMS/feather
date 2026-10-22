public import FeatherModuleKit
public import WebDomain

extension Page.Repository {
    public struct Scope: FeatherModuleKit.Scope {
        public let page: any Interface

        public init(page: any Interface) {
            self.page = page
        }
    }
}
