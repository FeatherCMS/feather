import AuthDomain
import AuthModule
import FeatherApplication
import FeatherModuleKit

extension Email.Remove {
    struct Action: PermissionAction {
        let key = Email.Permissions.delete
    }
}
