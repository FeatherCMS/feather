import FeatherModuleKit
import NewsletterModule

extension Issue.Add {
    struct Action: PermissionAction {
        let key = Issue.Permissions.create
    }
}
