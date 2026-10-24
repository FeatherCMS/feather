public import FeatherModuleKit
public import WebDomain
public import WebModule

extension Menu.Remove {
    public struct Scope: FeatherModuleKit.Scope {
        public let menu: any Menu.Repository.Interface

        public init(menu: any Menu.Repository.Interface) {
            self.menu = menu
        }
    }
}
