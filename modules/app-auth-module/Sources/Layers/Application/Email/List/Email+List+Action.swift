import AuthDomain
import AuthModule
import FeatherApplication
import FeatherModuleKit

extension Email.List {
    struct Action: PermissionAction {
        let key = Email.Permissions.list
    }
}
