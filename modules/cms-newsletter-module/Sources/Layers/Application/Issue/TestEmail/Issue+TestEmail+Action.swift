import FeatherModuleKit
import NewsletterModule

extension Issue.TestEmail {
    struct Action: PermissionAction {
        let key = Issue.Permissions.update
    }
}
