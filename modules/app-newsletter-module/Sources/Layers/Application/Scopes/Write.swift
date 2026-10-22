public import FeatherModuleKit
public import NewsletterDomain
public import NewsletterModule

public struct Write: Scope {
    public let newsletter: any Campaign.Repository.Interface
    public let subscriber: any Subscriber.Repository.Interface
    public let issue: any Issue.Repository.Interface
    public let delivery: any Delivery.Repository.Interface

    public init(
        newsletter: any Campaign.Repository.Interface,
        subscriber: any Subscriber.Repository.Interface,
        issue: any Issue.Repository.Interface,
        delivery: any Delivery.Repository.Interface
    ) {
        self.newsletter = newsletter
        self.subscriber = subscriber
        self.issue = issue
        self.delivery = delivery
    }
}
