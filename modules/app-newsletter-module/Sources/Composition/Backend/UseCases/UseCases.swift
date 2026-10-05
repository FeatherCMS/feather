public import FeatherContracts
import FeatherDatabase
import FeatherDomain
public import FeatherInfrastructure
public import NewsletterApplication
import NewsletterDomain
import NewsletterInfrastructure

public struct UseCases: Sendable {
    let databaseContext: DatabaseClientContext
    let authorizer: any Authorizer
    let jobs: any NewsletterJobs

    public init(
        databaseContext: DatabaseClientContext,
        authorizer: any Authorizer,
        jobs: any NewsletterJobs
    ) {
        self.databaseContext = databaseContext
        self.authorizer = authorizer
        self.jobs = jobs
    }

    func transaction() -> DatabaseTransactionExecutor<Write> {
        DatabaseTransactionExecutor(
            databaseContext: databaseContext,
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
            let shouldEnqueue = try await createPendingDelivery(
                issue: issue,
                email: subscriber.email
            )
            guard shouldEnqueue else { continue }
            try await jobs.enqueue(
                mailFrom: newsletter.fromEmail,
                mailTo: subscriber.email,
                subject: issue.subject,
                additionalHeaders: [],
                messageBody: issue.content,
                deliveryIssueId: issue.id,
                deliveryNewsletterId: issue.newsletterId,
                scheduledAt: issue.scheduledDate
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
        newsletterKey: String,
        email: String,
        subject: String,
        content: String
    ) async throws {
        let authSubject = try await CurrentSubject.require()
        let newsletter = try await makeGetNewsletterCampaign()
            .execute(subject: authSubject, input: .init(key: newsletterKey))
        guard !newsletter.fromEmail.isEmpty else { return }
        try await jobs.enqueue(
            mailFrom: newsletter.fromEmail,
            mailTo: email,
            subject: subject,
            additionalHeaders: [],
            messageBody: content,
            deliveryIssueId: nil,
            deliveryNewsletterId: nil,
            scheduledAt: nil
        )
    }

}
