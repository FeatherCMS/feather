import AuthDomain
import AuthModule
import FeatherApplication
import FeatherModuleKit

extension AuthEmail.Remove {
    struct Action: PermissionAction {
        let key = AuthEmail.Permissions.delete
    }
}
