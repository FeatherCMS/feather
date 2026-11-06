import AccountModule
import FeatherModuleKit

extension Account.Add {
    struct Action: PermissionAction {
        let key = Profile.Permissions.create
    }
}
