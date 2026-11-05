import FeatherApplication
import FeatherModuleKit
import NewsDomain
import NewsModule

extension Article.Search {
    struct Action: PermissionAction {
        let key = Article.Permissions.list
    }
}
