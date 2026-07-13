import Application
import NewsletterDomain

public struct CreateNewsletter: UseCase {
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
        public let name: String

        public init(name: String) {
            self.name = name
        }
    }

    public func execute(
        _ input: Input
    ) async throws -> NewsletterDetail {
        try await transaction.run { context in
            let model = try NewsletterCampaign.create(
                id: idGenerator.generate(),
                name: input.name
            )
            return (try await context.newsletter.insert(model)).asDetail
        }
    }
}
