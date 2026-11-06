import AccountModule
import FeatherModuleKit

extension Invitation.Remove {
    struct Action: PermissionAction {
        let key = Invitation.Permissions.delete
    }
}
