public import FeatherModuleKit
public import SystemModule

extension Permission.Edit {
    public struct Action: PermissionAction {
        public let key = SystemModule.Permission.Permissions.update
    }
}
