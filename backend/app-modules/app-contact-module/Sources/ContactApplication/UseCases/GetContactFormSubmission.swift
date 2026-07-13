import Application
import ContactDomain

public struct GetContactFormSubmission: UseCase {
    struct Error: UseCaseError { let message: String }
    let transaction: any TransactionExecutor<WriteContactForm>
    public init(transaction: any TransactionExecutor<WriteContactForm>) { self.transaction = transaction }
    public struct Input: DTO { public let id: String; public init(id: String) { self.id = id } }
    public func execute(_ input: Input) async throws -> ContactFormSubmissionDetail {
        try await transaction.run { context in
            guard let value = try await context.submission.findBy(id: input.id) else { throw Error(message: "Contact form submission not found") }
            return value.asDetail
        }
    }
}
