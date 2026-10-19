public import SystemModule
public import FeatherModuleKit

extension Permission.Add {
    public struct Action: PermissionAction {
        public let key = SystemModule.Permission.Permissions.create
    }
}
