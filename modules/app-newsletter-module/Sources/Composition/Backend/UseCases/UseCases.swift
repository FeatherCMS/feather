import FeatherApplication
import FeatherContracts
import FeatherDatabase
import FeatherDomain
import FeatherInfrastructure
import NewsletterApplication
import NewsletterContracts
import NewsletterDomain
import NewsletterInfrastructure

public protocol NewsletterMailQueue: Sendable {
    func enqueue(
        mailFrom: String,
        mailTo: String,
        subject: String,
        additionalHeaders: String,
        messageBody: String,
        deliveryIssueId: String?,
        deliveryNewsletterId: String?
    ) async throws
}

public struct UseCases: Sendable {
    let database: any DatabaseClient
    let idGenerator: any IDGenerator
    let authorizer: any Authorizer
    let mailQueue: any NewsletterMailQueue

    public init(
        database: any DatabaseClient,
        idGenerator: any IDGenerator,
        authorizer: any Authorizer,
        mailQueue: any NewsletterMailQueue
    ) {
        self.database = database
        self.idGenerator = idGenerator
        self.authorizer = authorizer
        self.mailQueue = mailQueue
    }

    func transaction() -> DatabaseTransactionExecutor<Write> {
        DatabaseTransactionExecutor(
            database: database,
            idGenerator: idGenerator,
            scope: { context in
                Write(
                    newsletter: CampaignDatabaseRepository(context: context),
                    subscriber: SubscriberDatabaseRepository(context: context),
                    issue: IssueDatabaseRepository(context: context),
                    delivery: DeliveryDatabaseRepository(context: context)
                )
            }
        )
    }

    func enqueueIssueEmails(
        issue: IssueDetail
    ) async throws {
        let subject = try await CurrentSubject.require()
        let newsletter = try await makeGetNewsletterCampaign()
            .execute(subject: subject, input: .init(id: issue.newsletterId))
        guard !newsletter.fromEmail.isEmpty else { return }
        let subscribers = try await makeListNewsletterSubscribers()
            .execute(
                subject: subject,
                input: .init(newsletterId: issue.newsletterId)
            )
        for subscriber in subscribers where subscriber.status == .subscribed {
            _ = try await createPendingDelivery(
                issue: issue,
                email: subscriber.email
            )
            try await mailQueue.enqueue(
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

    func createPendingDelivery(
        issue: IssueDetail,
        email: String
    ) async throws -> Bool {
        try await transaction()
            .run { context in
                guard
                    try await context.delivery.findBy(
                        issueId: issue.id,
                        subscriberEmail: email
                    ) == nil
                else {
                    return false
                }
                _ = try await context.delivery.insert(
                    .init(
                        issueId: issue.id,
                        newsletterId: issue.newsletterId,
                        subscriberEmail: email,
                        status: .pending,
                        sentDate: nil,
                        failureReason: nil
                    )
                )
                return true
            }
    }

    func enqueueIssueTestEmail(
        issue: IssueDetail,
        email: String
    ) async throws {
        let subject = try await CurrentSubject.require()
        let newsletter = try await makeGetNewsletterCampaign()
            .execute(subject: subject, input: .init(id: issue.newsletterId))
        guard !newsletter.fromEmail.isEmpty else { return }
        try await mailQueue.enqueue(
            mailFrom: newsletter.fromEmail,
            mailTo: email,
            subject: issue.subject,
            additionalHeaders: "",
            messageBody: issue.content,
            deliveryIssueId: nil,
            deliveryNewsletterId: nil
        )
    }

    func enqueueIssueTestEmail(
        newsletterId: String,
        email: String,
        subject: String,
        content: String
    ) async throws {
        let authSubject = try await CurrentSubject.require()
        let newsletter = try await makeGetNewsletterCampaign()
            .execute(subject: authSubject, input: .init(id: newsletterId))
        guard !newsletter.fromEmail.isEmpty else { return }
        try await mailQueue.enqueue(
            mailFrom: newsletter.fromEmail,
            mailTo: email,
            subject: subject,
            additionalHeaders: "",
            messageBody: content,
            deliveryIssueId: nil,
            deliveryNewsletterId: nil
        )
    }

}
