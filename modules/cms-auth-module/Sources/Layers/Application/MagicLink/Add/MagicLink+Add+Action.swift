import AuthDomain
import AuthModule
import FeatherApplication
import FeatherModuleKit

extension MagicLink.Add {
    struct Action: PermissionAction {
        let key = MagicLink.Permissions.create
    }
}
