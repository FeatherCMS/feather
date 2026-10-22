import FeatherModuleKit
import MediaModule

extension Asset.File.Edit {
    struct Action: PermissionAction {
        let key = Asset.Permissions.update
    }
}
