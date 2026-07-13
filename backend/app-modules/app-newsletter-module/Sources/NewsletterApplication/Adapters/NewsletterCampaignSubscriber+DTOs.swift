import NewsletterDomain

extension NewsletterCampaignSubscriber {
    var asDetail: NewsletterSubscriberDetail {
        .init(
            newsletterId: newsletterId,
            email: email,
            status: status,
            subscriptionDate: subscriptionDate,
            unsubscriptionDate: unsubscriptionDate,
            firstName: firstName,
            lastName: lastName,
            confirmedAt: confirmedAt,
            source: source,
            lastSentAt: lastSentAt,
            createdAt: createdAt,
            updatedAt: updatedAt
        )
    }
}
