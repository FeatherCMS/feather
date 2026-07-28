import Application
import NewsletterDomain

public struct CreateNewsletterIssue: UseCase {
    let transaction: any TransactionExecutor<WriteNewsletter>
    let idGenerator: any IDGenerator

    public init(
        transaction: any TransactionExecutor<WriteNewsletter>,
        idGenerator: any IDGenerator
    ) {
        self.transaction = transaction
        self.idGenerator = idGenerator
    }

    public struct Input: DTO {
        public let newsletterId: String
        public let subject: String
        public let previewText: String
        public let content: String

        public init(
            newsletterId: String,
            subject: String,
            previewText: String = "",
            content: String
        ) {
            self.newsletterId = newsletterId
            self.subject = subject
            self.previewText = previewText
            self.content = content
        }
    }

    public func execute(
        _ input: Input
    ) async throws -> NewsletterIssueDetail {
        try await transaction.run { context in
            let model = try NewsletterCampaignIssue.create(
                id: idGenerator.generate(),
                newsletterId: input.newsletterId,
                subject: input.subject,
                previewText: input.previewText,
                content: input.content
            )
            return (try await context.issue.insert(model)).asDetail
        }
    }
}
