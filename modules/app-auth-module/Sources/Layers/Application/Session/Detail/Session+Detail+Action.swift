import AuthModule
import FeatherApplication
import FeatherModuleKit

extension Session.Detail {
    struct Action: PermissionAction {
        let key = Session.Permissions.read
    }
}
