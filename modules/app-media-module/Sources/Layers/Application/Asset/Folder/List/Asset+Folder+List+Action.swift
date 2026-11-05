import FeatherModuleKit
import MediaModule

extension Asset.Folder.List {
    struct Action: PermissionAction {
        let key = Asset.Permissions.list
    }
}
