import FeatherModuleKit
import NewsletterModule

extension Campaign.Detail {
    struct Action: PermissionAction {
        let key = Campaign.Permissions.read
    }
}
