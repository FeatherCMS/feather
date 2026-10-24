import ContactModule
import FeatherModuleKit

extension Submission.Edit {
    struct Action: PermissionAction {
        let key = Submission.Permissions.update
    }
}
