public import FeatherModuleKit
public import NewsletterModule

extension Subscriber.Search {
    public struct Action: PermissionAction {
        public let key = Subscriber.Permissions.list
    }
}
