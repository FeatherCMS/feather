import AuthDomain
import AuthModule
import FeatherApplication
import FeatherModuleKit

extension Email.Add {
    struct Action: PermissionAction {
        let key = Email.Permissions.create
    }
}
