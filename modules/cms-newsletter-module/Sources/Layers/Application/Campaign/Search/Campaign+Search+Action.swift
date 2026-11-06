import FeatherModuleKit
import NewsletterModule

extension Campaign.Search {
    struct Action: PermissionAction {
        let key = Campaign.Permissions.list
    }
}
