import FeatherModuleKit
import MediaModule

extension Variant.Processor.Remove {
    struct Action: PermissionAction {
        let key = Variant.Processor.Permissions.delete
    }
}
