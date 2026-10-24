import AuthDomain
import AuthModule
import FeatherApplication
import FeatherModuleKit

extension MagicLink.Edit {
    struct Action: PermissionAction {
        let key = MagicLink.Permissions.update
    }
}
