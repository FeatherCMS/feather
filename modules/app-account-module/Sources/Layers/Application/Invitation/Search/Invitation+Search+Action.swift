import AccountModule
import FeatherModuleKit

extension Invitation.Search {
    struct Action: PermissionAction {
        let key = Invitation.Permissions.list
    }
}
