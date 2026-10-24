import AuthModule
import FeatherApplication
import FeatherModuleKit

extension MagicLink.List {
    struct Action: PermissionAction {
        let key = MagicLink.Permissions.list
    }
}
