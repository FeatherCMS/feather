import AccountModule
import FeatherModuleKit

extension Invitation.Detail {
    struct Action: PermissionAction {
        let key = Invitation.Permissions.read
    }
}
