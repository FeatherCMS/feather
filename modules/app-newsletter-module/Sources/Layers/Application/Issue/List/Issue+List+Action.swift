import FeatherModuleKit
import NewsletterModule

extension Issue.List {
    struct Action: PermissionAction {
        let key = Issue.Permissions.list
    }
}
