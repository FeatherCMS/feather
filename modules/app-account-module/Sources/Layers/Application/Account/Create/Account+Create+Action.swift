import AccountModule
import FeatherModuleKit

extension Account.Create {
    struct Action: PermissionAction {
        let key = Profile.Permissions.create
    }
}
