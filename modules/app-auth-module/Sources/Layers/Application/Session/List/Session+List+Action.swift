import AuthModule
import FeatherApplication
import FeatherModuleKit

extension Session.List {
    struct Action: PermissionAction {
        let key = Session.Permissions.list
    }
}
