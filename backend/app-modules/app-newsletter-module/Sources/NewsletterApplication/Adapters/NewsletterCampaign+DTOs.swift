import NewsletterDomain

extension NewsletterCampaign {
    var asDetail: NewsletterDetail {
        .init(
            id: id,
            name: name,
            fromEmail: fromEmail,
            createdAt: createdAt,
            updatedAt: updatedAt
        )
    }
}
