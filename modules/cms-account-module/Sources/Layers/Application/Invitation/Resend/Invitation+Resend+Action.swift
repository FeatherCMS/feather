import AccountModule
import FeatherModuleKit

extension Invitation.Resend {
    struct Action: PermissionAction {
        let key = Invitation.Permissions.create
    }
}
