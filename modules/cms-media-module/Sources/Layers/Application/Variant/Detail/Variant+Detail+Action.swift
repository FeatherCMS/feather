import FeatherModuleKit
import MediaModule

extension Variant.Detail {
    struct Action: PermissionAction { let key = Variant.Permissions.read }
}
