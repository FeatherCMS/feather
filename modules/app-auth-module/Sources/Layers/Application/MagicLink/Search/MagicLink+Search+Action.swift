import AuthDomain
import AuthModule
import FeatherApplication
import FeatherModuleKit

extension MagicLink.Search {
    struct Action: PermissionAction {
        let key = MagicLink.Permissions.list
    }
}
