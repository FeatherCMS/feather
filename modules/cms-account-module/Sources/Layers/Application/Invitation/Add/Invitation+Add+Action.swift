import AccountModule
import FeatherModuleKit

extension Invitation.Add {
    struct Action: PermissionAction {
        let key = Invitation.Permissions.create
    }
}
