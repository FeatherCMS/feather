public import FeatherModuleKit
public import NewsletterModule

extension Subscriber.Remove {
    public struct Action: PermissionAction {
        public let key = Subscriber.Permissions.delete
    }
}
