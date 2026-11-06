import AuthDomain
import AuthModule
import FeatherApplication
import FeatherModuleKit

extension Email.Edit {
    struct Action: PermissionAction {
        let key = Email.Permissions.update
    }
}
