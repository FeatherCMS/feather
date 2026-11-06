public import FeatherModuleKit
public import SystemModule

extension Permission.Detail {
    public struct Action: PermissionAction {
        public let key = SystemModule.Permission.Permissions.read
    }
}
