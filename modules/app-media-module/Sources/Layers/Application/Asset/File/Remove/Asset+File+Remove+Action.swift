import FeatherModuleKit
import MediaModule

extension Asset.File.Remove {
    struct Action: PermissionAction { let key = Asset.Permissions.delete }
}
