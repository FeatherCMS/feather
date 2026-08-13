import FeatherApplication
import FeatherContracts
import NewsletterDomain

public struct Write: Scope {
    public let newsletter: any CampaignRepository
    public let subscriber: any SubscriberRepository
    public let issue: any IssueRepository
    public let delivery: any DeliveryRepository

    public init(
        newsletter: any CampaignRepository,
        subscriber: any SubscriberRepository,
        issue: any IssueRepository,
        delivery: any DeliveryRepository
    ) {
        self.newsletter = newsletter
        self.subscriber = subscriber
        self.issue = issue
        self.delivery = delivery
    }
}
