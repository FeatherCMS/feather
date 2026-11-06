import AuthDomain
import AuthModule
import FeatherApplication
import FeatherModuleKit

extension Credential.Search {
    struct Action: PermissionAction {
        let key = Credential.Permissions.list
    }
}
