public import FeatherModuleKit
public import WebModule

extension MenuItem.Search {
    public struct Scope: FeatherModuleKit.Scope {
        public let menuItem: any Query.Interface

        public init(menuItem: any Query.Interface) {
            self.menuItem = menuItem
        }
    }
}
