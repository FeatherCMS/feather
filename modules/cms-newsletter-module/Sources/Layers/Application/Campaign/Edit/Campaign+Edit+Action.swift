import FeatherModuleKit
import NewsletterModule

extension Campaign.Edit {
    struct Action: PermissionAction {
        let key = Campaign.Permissions.update
    }
}
