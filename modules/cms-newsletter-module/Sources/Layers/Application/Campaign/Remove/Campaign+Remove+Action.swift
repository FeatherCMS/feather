import FeatherModuleKit
import NewsletterModule

extension Campaign.Remove {
    struct Action: PermissionAction {
        let key = Campaign.Permissions.delete
    }
}
