import AuthDomain
import AuthModule
import FeatherApplication
import FeatherModuleKit

extension Session.Extend {
    struct Action: PermissionAction {
        let key = Session.Permissions.update
    }
}
