public import FeatherModuleKit
public import WebModule

extension Menu.Public.List {
    public struct Scope: FeatherModuleKit.Scope {
        public let menuList: any Menu.List.Query.Interface
        public let menuLookup: any Menu.Lookup.Query.Interface
        public let menuItemList: any MenuItem.List.Query.Interface

        public init(
            menuList: any Menu.List.Query.Interface,
            menuLookup: any Menu.Lookup.Query.Interface,
            menuItemList: any MenuItem.List.Query.Interface
        ) {
            self.menuList = menuList
            self.menuLookup = menuLookup
            self.menuItemList = menuItemList
        }
    }
}
