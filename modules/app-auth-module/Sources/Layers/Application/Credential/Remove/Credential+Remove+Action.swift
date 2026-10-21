import AuthDomain
import AuthModule
import FeatherApplication
import FeatherModuleKit

extension Credential.Remove {
    struct Action: PermissionAction {
        let key = Credential.Permissions.delete
    }
}
