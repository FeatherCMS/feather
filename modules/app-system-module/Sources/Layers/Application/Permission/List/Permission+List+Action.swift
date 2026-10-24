public import FeatherModuleKit
public import SystemModule

extension Permission.List {
    public struct Action: PermissionAction {
        public let key = SystemModule.Permission.Permissions.list
    }
}
