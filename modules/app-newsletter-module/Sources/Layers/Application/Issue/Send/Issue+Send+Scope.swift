public import FeatherModuleKit
public import NewsletterDomain
public import NewsletterModule

extension Issue.Send {
    public struct Scope: FeatherModuleKit.Scope {
        public let newsletter: any Campaign.Repository.Interface
        public let subscriber: any Subscriber.Repository.Interface
        public let delivery: any Delivery.Repository.Interface

        public init(
            newsletter: any Campaign.Repository.Interface,
            subscriber: any Subscriber.Repository.Interface,
            delivery: any Delivery.Repository.Interface
        ) {
            self.newsletter = newsletter
            self.subscriber = subscriber
            self.delivery = delivery
        }
    }
}
