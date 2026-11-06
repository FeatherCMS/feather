import AuthModule
import FeatherApplication
import FeatherModuleKit

extension Session.Search {
    struct Action: PermissionAction {
        let key = Session.Permissions.list
    }
}
