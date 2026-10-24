public import FeatherModuleKit
public import SystemModule

extension Permission.Remove {
    public struct Action: PermissionAction {
        public let key = SystemModule.Permission.Permissions.delete
    }
}
