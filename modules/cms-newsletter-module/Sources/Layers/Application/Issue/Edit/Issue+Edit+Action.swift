import FeatherModuleKit
import NewsletterModule

extension Issue.Edit {
    struct Action: PermissionAction {
        let key = Issue.Permissions.update
    }
}
