import FeatherModuleKit
import NewsletterModule

extension Issue.Schedule {
    struct Action: PermissionAction {
        let key = Issue.Permissions.update
    }
}
