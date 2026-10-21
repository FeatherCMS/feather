import AuthModule
import FeatherApplication
import FeatherModuleKit

extension Session.ListByIdentity {
    struct Action: PermissionAction {
        let key = Session.Permissions.list
    }
}
