import NewsletterDomain

extension Subscriber {
    var asDetail: SubscriberDetail {
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
