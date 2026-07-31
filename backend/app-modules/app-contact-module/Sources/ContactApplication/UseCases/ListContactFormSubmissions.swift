import Application
import ContactDomain

public struct ListContactFormSubmissions: UseCase {
    let transaction: any TransactionExecutor<WriteContactForm>
    public init(transaction: any TransactionExecutor<WriteContactForm>) {
        self.transaction = transaction
    }
    public struct Input: DTO {
        public let formId: String
        public init(formId: String) { self.formId = formId }
    }
    public func execute(
        _ input: Input
    ) async throws -> [ContactFormSubmissionDetail] {
        try await transaction.run { context in
            try await context.submission.listBy(formId: input.formId)
                .map(\.asDetail)
        }
    }
}
