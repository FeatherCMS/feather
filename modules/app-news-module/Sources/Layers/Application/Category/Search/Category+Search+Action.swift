import FeatherApplication
import FeatherModuleKit
import NewsDomain
import NewsModule

extension Category.Search {
    struct Action: PermissionAction {
        let key = Category.Permissions.list
    }
}
