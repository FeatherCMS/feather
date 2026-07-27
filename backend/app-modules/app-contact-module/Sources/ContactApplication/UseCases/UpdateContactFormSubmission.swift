import Application
import ContactDomain

public struct UpdateContactFormSubmission: UseCase {
    struct Error: UseCaseError { let message: String }
    let transaction: any TransactionExecutor<WriteContactForm>
    public init(transaction: any TransactionExecutor<WriteContactForm>) {
        self.transaction = transaction
    }
    public struct Input: DTO {
        public let id: String
        public let status: ContactFormSubmission.Status
        public init(id: String, status: ContactFormSubmission.Status) {
            self.id = id
            self.status = status
        }
    }
    public func execute(
        _ input: Input
    ) async throws -> ContactFormSubmissionDetail {
        try await transaction.run { context in
            guard var value = try await context.submission.findBy(id: input.id)
            else { throw Error(message: "Contact form submission not found") }
            value.status = input.status
            return try await context.submission.update(value).asDetail
        }
    }
}
