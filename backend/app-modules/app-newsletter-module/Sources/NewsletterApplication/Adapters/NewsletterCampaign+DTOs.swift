import NewsletterDomain

extension NewsletterCampaign {
    var asDetail: NewsletterDetail {
        .init(
            id: id,
            name: name,
            createdAt: createdAt,
            updatedAt: updatedAt
        )
    }
}
