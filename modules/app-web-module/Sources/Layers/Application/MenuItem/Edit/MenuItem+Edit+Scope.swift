public import FeatherModuleKit
public import WebDomain

extension MenuItem.Edit {
    public struct Scope: FeatherModuleKit.Scope {
        public let menuItem: any MenuItem.Repository.Interface

        public init(menuItem: any MenuItem.Repository.Interface) {
            self.menuItem = menuItem
        }
    }
}
