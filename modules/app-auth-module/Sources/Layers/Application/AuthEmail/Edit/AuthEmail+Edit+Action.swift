import AuthDomain
import AuthModule
import FeatherApplication
import FeatherModuleKit

extension AuthEmail.Edit {
    struct Action: PermissionAction {
        let key = AuthEmail.Permissions.update
    }
}
