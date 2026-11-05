public import FeatherModuleKit
public import NewsletterModule

extension Subscriber.List {
    public struct Action: PermissionAction {
        public let key = Subscriber.Permissions.list
    }
}
