import AuthModule
import FeatherApplication
import FeatherModuleKit

extension Credential.Detail {
    struct Action: PermissionAction {
        let key = Credential.Permissions.read
    }
}
