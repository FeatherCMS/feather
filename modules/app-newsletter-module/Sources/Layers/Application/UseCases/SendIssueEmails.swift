import NewsletterContracts
import NewsletterDomain
public import FeatherApplication
public import FeatherContracts
import FeatherMail
public import Foundation

public struct SendIssueEmails: UseCase {
    struct CampaignReadAction: PermissionAction {
        let key = Permissions.Campaigns.read
    }

    struct SubscriberListAction: PermissionAction {
        let key = Permissions.Subscribers.list
    }

    let authorizer: any Authorizer
    let transaction: any TransactionExecutor<Write>
    let jobs: any NewsletterIssueJobController

    public init(
        authorizer: any Authorizer,
        transaction: any TransactionExecutor<Write>,
        jobs: any NewsletterIssueJobController
    ) {
        self.authorizer = authorizer
        self.transaction = transaction
        self.jobs = jobs
    }

    public struct Input: DTO {
        public let issueId: String
        public let newsletterId: String
        public let subject: String
        public let content: String
        public let scheduledDate: Date?

        public init(issue: IssueDetail) {
            self.issueId = issue.id
            self.newsletterId = issue.newsletterId
            self.subject = issue.subject
            self.content = issue.content
            self.scheduledDate = issue.scheduledDate
        }
    }

    public func execute(
        subject: Subject,
        input: Input
    ) async throws {
        let campaignReadAction = CampaignReadAction()
        guard
            try await authorizer.can(
                subject: subject,
                perform: campaignReadAction
            )
        else {
            throw AuthError(
                kind: .forbidden,
                message: campaignReadAction.key.rawValue
            )
        }

        let subscriberListAction = SubscriberListAction()
        guard
            try await authorizer.can(
                subject: subject,
                perform: subscriberListAction
            )
        else {
            throw AuthError(
                kind: .forbidden,
                message: subscriberListAction.key.rawValue
            )
        }

        let newsletter = try await transaction.run { scope in
            guard let newsletter = try await scope.newsletter.findBy(
                id: input.newsletterId
            )
            else {
                throw Error.newsletterNotFound
            }
            return newsletter
        }
        guard !newsletter.fromEmail.isEmpty else { return }

        let subscribers = try await transaction.run { scope in
            try await scope.subscriber.list(newsletterId: input.newsletterId)
        }
        for subscriber in subscribers where subscriber.status == .subscribed {
            let shouldEnqueue = try await createPendingDelivery(
                issueId: input.issueId,
                newsletterId: input.newsletterId,
                email: subscriber.email
            )
            guard shouldEnqueue else { continue }
            try await jobs.enqueueIssue(
                mail: .init(
                    from: .init(newsletter.fromEmail),
                    to: [.init(subscriber.email)],
                    subject: input.subject,
                    body: .html(input.content)
                ),
                issueId: input.issueId,
                newsletterId: input.newsletterId,
                scheduledAt: input.scheduledDate
            )
        }
    }

    private func createPendingDelivery(
        issueId: String,
        newsletterId: String,
        email: String
    ) async throws -> Bool {
        try await transaction.run { context in
            guard
                try await context.delivery.findBy(
                    issueId: issueId,
                    subscriberEmail: email
                ) == nil
            else {
                return false
            }
            _ = try await context.delivery.insert(
                .init(
                    issueId: issueId,
                    newsletterId: newsletterId,
                    subscriberEmail: email,
                    status: .pending,
                    sentDate: nil,
                    failureReason: nil
                )
            )
            return true
        }
    }

    public enum Error: UseCaseError {
        case newsletterNotFound
    }
}
