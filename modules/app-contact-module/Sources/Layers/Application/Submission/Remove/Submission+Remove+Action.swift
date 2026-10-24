import ContactModule
import FeatherModuleKit

extension Submission.Remove {
    struct Action: PermissionAction {
        let key = Submission.Permissions.delete
    }
}
