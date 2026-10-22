import AccountModule
import FeatherModuleKit

extension Invitation.List {
    struct Action: PermissionAction {
        let key = Invitation.Permissions.list
    }
}
