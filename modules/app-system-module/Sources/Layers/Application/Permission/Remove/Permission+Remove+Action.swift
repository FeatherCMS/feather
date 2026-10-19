public import SystemModule
public import FeatherModuleKit

extension Permission.Remove {
    public struct Action: PermissionAction {
        public let key = SystemModule.Permission.Permissions.delete
    }
}
