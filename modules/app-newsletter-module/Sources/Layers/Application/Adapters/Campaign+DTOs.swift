import NewsletterDomain

extension Campaign {
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
