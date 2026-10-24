import FeatherModuleKit
import MediaModule

extension Variant.Remove {
    struct Action: PermissionAction {
        let key = Variant.Permissions.delete
    }
}
