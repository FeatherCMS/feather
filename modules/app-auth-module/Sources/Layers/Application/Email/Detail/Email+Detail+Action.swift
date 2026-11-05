import AuthDomain
import AuthModule
import FeatherApplication
import FeatherModuleKit

extension Email.Detail {
    struct Action: PermissionAction {
        let key = Email.Permissions.read
    }
}
