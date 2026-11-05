import FeatherModuleKit
import MediaModule

extension Asset.File.Resolve {
    struct Action: PermissionAction {
        let key = Asset.Permissions.list
    }
}
