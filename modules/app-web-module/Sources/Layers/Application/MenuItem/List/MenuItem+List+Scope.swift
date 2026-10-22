public import FeatherModuleKit
public import WebDomain

extension MenuItem.List {
    public struct Scope: FeatherModuleKit.Scope {
        public let menuItem: any Query.Interface

        public init(menuItem: any Query.Interface) {
            self.menuItem = menuItem
        }
    }
}
