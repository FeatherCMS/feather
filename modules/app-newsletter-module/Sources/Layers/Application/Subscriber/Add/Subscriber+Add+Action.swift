import FeatherModuleKit
import NewsletterModule

extension Subscriber.Add {
    public struct Action: PermissionAction {
        public let key = Subscriber.Permissions.create
    }
}
