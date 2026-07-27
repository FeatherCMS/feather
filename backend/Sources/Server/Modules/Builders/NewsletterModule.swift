import Infrastructure
import NewsletterApplication
import NewsletterInfrastructure
import NewsletterDomain
import Application
import Environment
import Jobs

struct NewsletterModule: Sendable {
    private let infrastructure: AppInfrastructure
    private let authorizer: any Authorizer

    init(
        infrastructure: AppInfrastructure,
        authorizer: any Authorizer
    ) {
        self.infrastructure = infrastructure
        self.authorizer = authorizer
    }

    func aggregatedPermissions() {
        for permission in NewsletterPermissions.allPermissions() {
            print(permission.rawValue)
        }
    }

    func authorize(permission: PermissionKey) async throws {
        let subject = try await CurrentSubject.require()
        guard try await authorizer.can(subject: subject, perform: NewsletterPermissionAction(key: permission)) else {
            throw AuthError(kind: .forbidden, message: permission.rawValue)
        }
    }

    private func transaction() -> DatabaseTransactionExecutor<WriteNewsletter> {
        DatabaseTransactionExecutor(
            database: infrastructure.database,
            scope: { connection in
                WriteNewsletter(
                    newsletter: DatabaseNewsletterCampaignRepository(connection: connection),
                    subscriber: DatabaseNewsletterCampaignSubscriberRepository(connection: connection),
                    issue: DatabaseNewsletterCampaignIssueRepository(connection: connection),
                    delivery: DatabaseNewsletterCampaignDeliveryRepository(connection: connection)
                )
            }
        )
    }

    func makeCreateNewsletter() -> CreateNewsletter {
        .init(transaction: transaction(), idGenerator: infrastructure.idGenerator)
    }

    func makeListNewsletters() -> ListNewsletters { .init(transaction: transaction()) }
    func makeGetNewsletter() -> GetNewsletter { .init(transaction: transaction()) }
    func makeUpdateNewsletter() -> UpdateNewsletter { .init(transaction: transaction()) }
    func makeDeleteNewsletter() -> DeleteNewsletter { .init(transaction: transaction()) }

    func makeCreateNewsletterIssue() -> CreateNewsletterIssue {
        .init(transaction: transaction(), idGenerator: infrastructure.idGenerator)
    }

    func enqueueIssueEmails(
        issue: NewsletterIssueDetail
    ) async throws {
        let newsletter = try await makeGetNewsletter().execute(.init(id: issue.newsletterId))
        guard !newsletter.fromEmail.isEmpty else { return }
        let subscribers = try await makeListNewsletterSubscribers().execute(
            .init(newsletterId: issue.newsletterId)
        )
        for subscriber in subscribers where subscriber.status == .subscribed {
            _ = try await createPendingDelivery(issue: issue, email: subscriber.email)
            try await infrastructure.jobQueue.enqueueContactFormMail(
                mailFrom: newsletter.fromEmail,
                mailTo: subscriber.email,
                subject: issue.subject,
                additionalHeaders: "",
                messageBody: issue.content,
                deliveryIssueId: issue.id,
                deliveryNewsletterId: issue.newsletterId
            )
        }
    }

    private func createPendingDelivery(
        issue: NewsletterIssueDetail,
        email: String
    ) async throws -> Bool {
        try await transaction().run { context in
            guard try await context.delivery.findBy(issueId: issue.id, subscriberEmail: email) == nil else {
                return false
            }
            _ = try await context.delivery.insert(.init(
                issueId: issue.id,
                newsletterId: issue.newsletterId,
                subscriberEmail: email,
                status: .pending,
                sentDate: nil,
                failureReason: nil
            ))
            return true
        }
    }

    func enqueueIssueTestEmail(
        issue: NewsletterIssueDetail,
        email: String
    ) async throws {
        let newsletter = try await makeGetNewsletter().execute(.init(id: issue.newsletterId))
        guard !newsletter.fromEmail.isEmpty else { return }
        try await infrastructure.jobQueue.enqueueContactFormMail(
            mailFrom: newsletter.fromEmail,
            mailTo: email,
            subject: issue.subject,
            additionalHeaders: "",
            messageBody: issue.content
        )
    }

    func enqueueIssueTestEmail(
        newsletterId: String,
        email: String,
        subject: String,
        content: String
    ) async throws {
        let newsletter = try await makeGetNewsletter().execute(.init(id: newsletterId))
        guard !newsletter.fromEmail.isEmpty else { return }
        try await infrastructure.jobQueue.enqueueContactFormMail(
            mailFrom: newsletter.fromEmail,
            mailTo: email,
            subject: subject,
            additionalHeaders: "",
            messageBody: content
        )
    }

    func makeListNewsletterIssues() -> ListNewsletterIssues { .init(transaction: transaction()) }
    func makeListNewsletterDeliveries() -> ListNewsletterDeliveries { .init(transaction: transaction()) }
    func makeGetNewsletterIssue() -> GetNewsletterIssue { .init(transaction: transaction()) }
    func makeUpdateNewsletterIssue() -> UpdateNewsletterIssue { .init(transaction: transaction()) }
    func makeDeleteNewsletterIssue() -> DeleteNewsletterIssue { .init(transaction: transaction()) }

    func makeScheduleNewsletterIssue() -> ScheduleNewsletterIssue {
        .init(transaction: transaction(), clock: DefaultClock())
    }

    func makeSubscribeToNewsletter() -> SubscribeToNewsletter {
        .init(transaction: transaction(), clock: DefaultClock())
    }

    func makeUnsubscribeFromNewsletter() -> UnsubscribeFromNewsletter {
        .init(transaction: transaction(), clock: DefaultClock())
    }

    func makeListNewsletterSubscribers() -> ListNewsletterSubscribers { .init(transaction: transaction()) }
    func makeGetNewsletterSubscriber() -> GetNewsletterSubscriber { .init(transaction: transaction()) }
    func makeCreateNewsletterSubscriber() -> CreateNewsletterSubscriber { .init(transaction: transaction(), clock: DefaultClock()) }
    func makeUpdateNewsletterSubscriber() -> UpdateNewsletterSubscriber { .init(transaction: transaction(), clock: DefaultClock()) }
    func makeDeleteNewsletterSubscriber() -> DeleteNewsletterSubscriber { .init(transaction: transaction()) }
}
