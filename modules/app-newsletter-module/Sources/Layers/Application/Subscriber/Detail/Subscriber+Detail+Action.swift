import FeatherModuleKit
import NewsletterModule

extension Subscriber.Detail {
    public struct Action: PermissionAction {
        public let key = Subscriber.Permissions.read
    }
}
