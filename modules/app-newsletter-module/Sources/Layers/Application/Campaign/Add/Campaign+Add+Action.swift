import FeatherModuleKit
import NewsletterModule

extension Campaign.Add {
    struct Action: PermissionAction {
        let key = Campaign.Permissions.create
    }
}
