public import FeatherModuleKit
public import WebModule

extension Menu.Public.List {
    public struct Scope: FeatherModuleKit.Scope {
        public let menuList: any Menu.List.Query.Interface
        public let menuLookup: any Menu.Lookup.Query.Interface
        public let menuItems: any Query.Interface

        public init(
            menuList: any Menu.List.Query.Interface,
            menuLookup: any Menu.Lookup.Query.Interface,
            menuItems: any Query.Interface
        ) {
            self.menuList = menuList
            self.menuLookup = menuLookup
            self.menuItems = menuItems
        }
    }
}
