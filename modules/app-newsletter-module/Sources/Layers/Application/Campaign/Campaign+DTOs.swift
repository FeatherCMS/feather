import NewsletterDomain
import NewsletterModule

extension Campaign.Model {
    var asDetail: CampaignDetail {
        .init(
            id: id,
            key: key,
            name: name,
            fromEmail: fromEmail,
            createdAt: createdAt,
            updatedAt: updatedAt
        )
    }
}
