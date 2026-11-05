import AuthModule
import FeatherApplication
import FeatherModuleKit

extension MagicLink.Detail {
    struct Action: PermissionAction {
        let key = MagicLink.Permissions.read
    }
}
