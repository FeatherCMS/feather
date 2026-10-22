import FeatherModuleKit
import NewsletterModule

extension Subscriber.Edit {
    public struct Action: PermissionAction {
        public let key = Subscriber.Permissions.update
    }
}
