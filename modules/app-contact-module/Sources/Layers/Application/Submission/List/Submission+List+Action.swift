import ContactModule
import FeatherModuleKit

extension Submission.List {
    struct Action: PermissionAction {
        let key = Submission.Permissions.list
    }
}
