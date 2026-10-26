import FeatherModuleKit
import NewsletterModule

extension Issue.Search {
    struct Action: PermissionAction {
        let key = Issue.Permissions.list
    }
}
