import AuthDomain
import AuthModule
import FeatherApplication
import FeatherDomain
import FeatherModuleKit

extension Credential.Edit {
    struct Action: PermissionAction {
        let key = Credential.Permissions.update
    }
}
