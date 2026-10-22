public import FeatherModuleKit
public import WebModule

extension Menu.Public {
    public struct Scope: FeatherModuleKit.Scope {
        public let menuList: any Menu.List.Query.Interface
        public let menuDetail: any Menu.Detail.Query.Interface
        public let menuItemList: any MenuItem.List.Query.Interface

        public init(
            menuList: any Menu.List.Query.Interface,
            menuDetail: any Menu.Detail.Query.Interface,
            menuItemList: any MenuItem.List.Query.Interface
        ) {
            self.menuList = menuList
            self.menuDetail = menuDetail
            self.menuItemList = menuItemList
        }
    }
}
