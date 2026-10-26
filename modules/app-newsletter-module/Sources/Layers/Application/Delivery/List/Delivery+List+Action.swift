import FeatherModuleKit
import NewsletterModule

extension Delivery.List {
    struct Action: PermissionAction {
        let key = Issue.Permissions.read
    }
}
