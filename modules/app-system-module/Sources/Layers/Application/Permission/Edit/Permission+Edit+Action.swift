public import SystemModule
public import FeatherModuleKit

extension Permission.Edit {
    public struct Action: PermissionAction {
        public let key = SystemModule.Permission.Permissions.update
    }
}
