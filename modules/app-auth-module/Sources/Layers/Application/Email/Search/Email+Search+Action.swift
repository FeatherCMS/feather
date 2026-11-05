import AuthDomain
import AuthModule
import FeatherApplication
import FeatherModuleKit

extension Email.Search {
    struct Action: PermissionAction {
        let key = Email.Permissions.list
    }
}
