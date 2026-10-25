public import FeatherModuleKit
public import WebModule

extension Menu.Public.List {
    public struct Scope: FeatherModuleKit.Scope {
        public let menuList: any Menu.List.Query.Interface
        public let menuItems: any Query.Interface

        public init(
            menuList: any Menu.List.Query.Interface,
            menuItems: any Query.Interface
        ) {
            self.menuList = menuList
            self.menuItems = menuItems
        }
    }
}
