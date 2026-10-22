public import FeatherModuleKit
public import WebDomain
import WebModule

extension Menu.Add {
    public struct Action: PermissionAction {
        public let key = WebModule.Permissions.Menus.create
    }
}
