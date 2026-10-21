import AuthDomain
import AuthModule
import FeatherApplication
import FeatherModuleKit

extension AuthEmail.List {
    struct Action: PermissionAction {
        let key = AuthEmail.Permissions.list
    }
}
