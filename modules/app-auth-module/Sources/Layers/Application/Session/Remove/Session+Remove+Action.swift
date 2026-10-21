import AuthDomain
import AuthModule
import FeatherApplication
import FeatherModuleKit

extension Session.Remove {
    struct Action: PermissionAction {
        let key = Session.Permissions.delete
    }
}
