import FeatherModuleKit
import MediaModule

extension Asset.File.Detail {
    struct Action: PermissionAction {
        let key = Asset.Permissions.read
    }
}
