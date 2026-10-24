public import FeatherModuleKit
public import NewsletterDomain
public import NewsletterModule

extension Subscriber.Add {
    public struct Scope: FeatherModuleKit.Scope {
        public let newsletter: any Campaign.Repository.Interface
        public let subscriber: any Subscriber.Repository.Interface

        public init(
            newsletter: any Campaign.Repository.Interface,
            subscriber: any Subscriber.Repository.Interface
        ) {
            self.newsletter = newsletter
            self.subscriber = subscriber
        }
    }
}
