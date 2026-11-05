import AuthDomain
import AuthModule
import FeatherApplication
import FeatherDomain
import FeatherModuleKit

extension Credential.Add {
    struct Action: PermissionAction {
        let key = Credential.Permissions.create
    }
}
