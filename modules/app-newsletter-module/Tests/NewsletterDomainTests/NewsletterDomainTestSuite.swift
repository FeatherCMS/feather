import Testing

import struct Foundation.Date

@testable import NewsletterDomain

@Suite
struct NewsletterDomainTestSuite {
    @Test
    func newsletterValidatesName() throws {
        let newsletter = try Campaign.create(
            name: "Product updates"
        )
        #expect(newsletter.name == "Product updates")
    }

    @Test
    func subscriberCanUnsubscribeAndResubscribe() throws {
        let date = Date(timeIntervalSince1970: 100)
        let subscriber = try Subscriber.create(
            newsletterId: "newsletter-1",
            email: "person@example.com",
            subscriptionDate: date
        )
        var model = Subscriber(
            newsletterId: subscriber.newsletterId,
            email: subscriber.email,
            status: subscriber.status,
            subscriptionDate: subscriber.subscriptionDate,
            unsubscriptionDate: subscriber.unsubscriptionDate,
            firstName: subscriber.firstName,
            lastName: subscriber.lastName,
            confirmedAt: subscriber.confirmedAt,
            unsubscribeToken: subscriber.unsubscribeToken,
            source: subscriber.source,
            lastSentAt: subscriber.lastSentAt,
            createdAt: date,
            updatedAt: date
        )
        model.unsubscribe(at: Date(timeIntervalSince1970: 200))
        model.subscribe(at: Date(timeIntervalSince1970: 300))
        #expect(model.status == .subscribed)
        #expect(model.unsubscriptionDate == nil)
    }

    @Test
    func issueRejectsPastSchedule() throws {
        let issue = try Issue.create(
            newsletterId: "newsletter-1",
            subject: "Updates",
            content: "Body"
        )
        var model = Issue(
            id: "issue-1",
            newsletterId: issue.newsletterId,
            subject: issue.subject,
            previewText: issue.previewText,
            content: issue.content,
            status: issue.status,
            scheduledDate: issue.scheduledDate,
            sentDate: nil,
            createdAt: .distantPast,
            updatedAt: .distantPast
        )
        #expect(throws: Issue.Error.invalidSchedule) {
            try model.schedule(
                at: Date(timeIntervalSince1970: 99),
                now: Date(timeIntervalSince1970: 100)
            )
        }
    }
}
