import FeatherModuleKit
import NewsletterModule

extension Campaign.List {
    struct Action: PermissionAction {
        let key = Campaign.Permissions.list
    }
}
