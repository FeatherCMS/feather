public import SystemModule
public import FeatherModuleKit

extension Permission.List {
    public struct Action: PermissionAction {
        public let key = SystemModule.Permission.Permissions.list
    }
}
