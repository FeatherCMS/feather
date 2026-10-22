public import FeatherModuleKit
public import WebDomain

extension MenuItem.Detail {
    public struct Scope: FeatherModuleKit.Scope {
        public let menuItem: any Query.Interface

        public init(menuItem: any Query.Interface) {
            self.menuItem = menuItem
        }
    }
}
