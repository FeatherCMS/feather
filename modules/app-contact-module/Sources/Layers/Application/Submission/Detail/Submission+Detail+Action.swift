import ContactModule
import FeatherModuleKit

extension Submission.Detail {
    struct Action: PermissionAction {
        let key = Submission.Permissions.read
    }
}
