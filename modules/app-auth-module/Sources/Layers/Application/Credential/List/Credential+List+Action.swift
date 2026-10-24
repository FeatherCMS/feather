import AuthModule
import FeatherApplication
import FeatherModuleKit

extension Credential.List {
    struct Action: PermissionAction {
        let key = Credential.Permissions.list
    }
}
