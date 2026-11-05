import FeatherModuleKit
import MediaModule

extension Asset.File.Add {
    struct Action: PermissionAction {
        let key = Asset.Permissions.create
    }
}
