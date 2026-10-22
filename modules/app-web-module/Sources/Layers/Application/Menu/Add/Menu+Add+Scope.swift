public import FeatherModuleKit
public import WebDomain

extension Menu.Add {
    public struct Scope: FeatherModuleKit.Scope {
        public let menu: any Menu.Repository.Interface

        public init(menu: any Menu.Repository.Interface) {
            self.menu = menu
        }
    }
}
