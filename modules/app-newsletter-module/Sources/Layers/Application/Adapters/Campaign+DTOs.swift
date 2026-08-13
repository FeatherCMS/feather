import NewsletterDomain

extension Campaign {
    var asDetail: CampaignDetail {
        .init(
            id: id,
            name: name,
            fromEmail: fromEmail,
            createdAt: createdAt,
            updatedAt: updatedAt
        )
    }
}
