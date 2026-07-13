import Application
import ContactDomain

public struct CreateContactForm: UseCase {
    let transaction: any TransactionExecutor<WriteContactForm>
    let idGenerator: any IDGenerator

    public init(transaction: any TransactionExecutor<WriteContactForm>, idGenerator: any IDGenerator) {
        self.transaction = transaction
        self.idGenerator = idGenerator
    }

    public struct Input: DTO {
        public let name: String
        public init(name: String) { self.name = name }
    }

    public func execute(_ input: Input) async throws -> ContactFormDetail {
        try await transaction.run { context in
            let model = try ContactForm.create(id: idGenerator.generate(), name: input.name)
            return (try await context.form.insert(model)).asDetail
        }
    }
}
