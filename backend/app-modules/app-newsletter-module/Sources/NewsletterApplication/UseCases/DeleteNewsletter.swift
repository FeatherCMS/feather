import Application
import NewsletterDomain

public struct DeleteNewsletter: UseCase {
    let transaction: any TransactionExecutor<WriteNewsletter>
    public init(transaction: any TransactionExecutor<WriteNewsletter>) {
        self.transaction = transaction
    }
    public struct Input: DTO {
        public let id: String
        public init(id: String) { self.id = id }
    }
    public func execute(_ input: Input) async throws -> Bool {
        try await transaction.run { context in
            try await context.newsletter.delete(id: input.id)
        }
    }
}
