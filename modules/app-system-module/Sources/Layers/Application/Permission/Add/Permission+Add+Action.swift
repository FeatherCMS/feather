public import FeatherModuleKit
public import SystemModule

extension Permission.Add {
    public struct Action: PermissionAction {
        public let key = SystemModule.Permission.Permissions.create
    }
}
