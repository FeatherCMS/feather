import Application
import NewsletterDomain
import Foundation

public struct UpdateNewsletterIssue: UseCase {
    let transaction: any TransactionExecutor<WriteNewsletter>

    public init(transaction: any TransactionExecutor<WriteNewsletter>) {
        self.transaction = transaction
    }

    public struct Input: DTO {
        public let id: String
        public let subject: String
        public let content: String
        public let scheduledDate: Date?

        public init(
            id: String,
            subject: String,
            content: String,
            scheduledDate: Date?
        ) {
            self.id = id
            self.subject = subject
            self.content = content
            self.scheduledDate = scheduledDate
        }
    }

    public func execute(
        _ input: Input
    ) async throws -> NewsletterIssueDetail {
        try await transaction.run { context in
            guard var issue = try await context.issue.findBy(id: input.id)
            else {
                throw Error.notFound
            }
            guard !input.subject.isEmpty else {
                throw NewsletterCampaignIssue.Error.subjectTooShort
            }
            guard input.subject.count < 255 else {
                throw NewsletterCampaignIssue.Error.subjectTooLong
            }
            guard !input.content.isEmpty else {
                throw NewsletterCampaignIssue.Error.contentTooShort
            }
            issue.subject = input.subject
            issue.content = input.content
            issue.scheduledDate = input.scheduledDate
            issue.status = input.scheduledDate == nil ? .draft : .scheduled
            return (try await context.issue.update(issue)).asDetail
        }
    }

    public enum Error: UseCaseError {
        case notFound
    }
}
