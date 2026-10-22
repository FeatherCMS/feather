public import FeatherModuleKit
public import WebDomain

extension Menu.Search {
    public struct Scope: FeatherModuleKit.Scope {
        public let menu: any Query.Interface

        public init(menu: any Query.Interface) {
            self.menu = menu
        }
    }
}
