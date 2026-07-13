import Application
import NewsletterDomain

public struct WriteNewsletter: Scope {
    public let newsletter: any NewsletterCampaignRepository
    public let subscriber: any NewsletterCampaignSubscriberRepository
    public let issue: any NewsletterCampaignIssueRepository
    public let delivery: any NewsletterCampaignDeliveryRepository

    public init(
        newsletter: any NewsletterCampaignRepository,
        subscriber: any NewsletterCampaignSubscriberRepository,
        issue: any NewsletterCampaignIssueRepository,
        delivery: any NewsletterCampaignDeliveryRepository
    ) {
        self.newsletter = newsletter
        self.subscriber = subscriber
        self.issue = issue
        self.delivery = delivery
    }
}
