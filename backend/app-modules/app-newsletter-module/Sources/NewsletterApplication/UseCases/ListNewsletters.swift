import Application
import NewsletterDomain

public struct ListNewsletters: UseCase {
    let transaction: any TransactionExecutor<WriteNewsletter>
    public init(transaction: any TransactionExecutor<WriteNewsletter>) {
        self.transaction = transaction
    }
    public struct Input: DTO { public init() {} }
    public func execute(_ input: Input) async throws -> [NewsletterDetail] {
        try await transaction.run { context in
            try await context.newsletter.list().map(\.asDetail)
        }
    }
}
