import FeatherModuleKit
import NewsletterModule

extension Issue.Send {
    struct SubscriberListAction: PermissionAction {
        let key = Subscriber.Permissions.list
    }
}
