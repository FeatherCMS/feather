import AuthDomain
import AuthModule
import FeatherApplication
import FeatherModuleKit

extension AuthEmail.Add {
    struct Action: PermissionAction {
        let key = AuthEmail.Permissions.create
    }
}
