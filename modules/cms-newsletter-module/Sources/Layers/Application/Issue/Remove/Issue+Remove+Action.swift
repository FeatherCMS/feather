import FeatherModuleKit
import NewsletterModule

extension Issue.Remove {
    struct Action: PermissionAction {
        let key = Issue.Permissions.delete
    }
}
