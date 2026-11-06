import FeatherModuleKit
import NewsletterModule

extension Issue.Detail {
    struct Action: PermissionAction {
        let key = Issue.Permissions.read
    }
}
