import FeatherApplication
import FeatherContracts
import FeatherDatabase
import FeatherDomain
import FeatherInfrastructure
import NewsletterApplication
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

public struct NewsletterBackend: Sendable {
    private let database: any DatabaseClient
    private let idGenerator: any IDGenerator
    let authorizer: any Authorizer
    private let mailQueue: any NewsletterMailQueue

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

    func aggregatedPermissions() {
        for permission in Permissions.allPermissions() {
            print(permission.rawValue)
        }
    }

    private func transaction() -> DatabaseTransactionExecutor<Write> {
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

    func makeCreateNewsletterCampaign() -> CreateCampaign {
        .init(
            authorizer: authorizer,
            transaction: transaction()
        )
    }

    func makeListNewsletterCampaigns() -> ListCampaigns {
        .init(authorizer: authorizer, transaction: transaction())
    }
    func makeGetNewsletterCampaign() -> GetCampaign {
        .init(authorizer: authorizer, transaction: transaction())
    }
    func makeUpdateNewsletterCampaign() -> UpdateCampaign {
        .init(authorizer: authorizer, transaction: transaction())
    }
    func makeDeleteNewsletterCampaign() -> DeleteCampaign {
        .init(authorizer: authorizer, transaction: transaction())
    }

    func makeCreateNewsletterIssue() -> CreateIssue {
        .init(
            authorizer: authorizer,
            transaction: transaction()
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

    private func createPendingDelivery(
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

    func makeListNewsletterIssues() -> ListIssues {
        .init(authorizer: authorizer, transaction: transaction())
    }
    func makeListNewsletterDeliveries() -> ListDeliveries {
        .init(authorizer: authorizer, transaction: transaction())
    }
    func makeGetNewsletterIssue() -> GetIssue {
        .init(authorizer: authorizer, transaction: transaction())
    }
    func makeUpdateNewsletterIssue() -> UpdateIssue {
        .init(authorizer: authorizer, transaction: transaction())
    }
    func makeDeleteNewsletterIssue() -> DeleteIssue {
        .init(authorizer: authorizer, transaction: transaction())
    }

    func makeScheduleNewsletterIssue() -> ScheduleIssue {
        .init(
            authorizer: authorizer,
            transaction: transaction()
        )
    }

    func makeSubscribeToNewsletter() -> Subscribe {
        .init(transaction: transaction())
    }

    func makeUnsubscribeFromNewsletter() -> Unsubscribe {
        .init(transaction: transaction())
    }

    func makeListNewsletterSubscribers() -> ListSubscribers {
        .init(authorizer: authorizer, transaction: transaction())
    }
    func makeGetNewsletterSubscriber() -> GetSubscriber {
        .init(authorizer: authorizer, transaction: transaction())
    }
    func makeCreateNewsletterSubscriber() -> CreateSubscriber {
        .init(
            authorizer: authorizer,
            transaction: transaction()
        )
    }
    func makeUpdateNewsletterSubscriber() -> UpdateSubscriber {
        .init(
            authorizer: authorizer,
            transaction: transaction()
        )
    }
    func makeDeleteNewsletterSubscriber() -> DeleteSubscriber {
        .init(authorizer: authorizer, transaction: transaction())
    }
}
