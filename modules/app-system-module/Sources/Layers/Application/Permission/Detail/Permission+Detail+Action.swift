public import SystemModule
public import FeatherModuleKit

extension Permission.Detail {
    public struct Action: PermissionAction {
        public let key = SystemModule.Permission.Permissions.read
    }
}
