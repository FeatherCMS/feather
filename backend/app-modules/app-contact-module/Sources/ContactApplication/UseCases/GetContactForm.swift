import Application
import ContactDomain

public struct GetContactForm: UseCase {
    let transaction: any TransactionExecutor<WriteContactForm>
    public init(transaction: any TransactionExecutor<WriteContactForm>) { self.transaction = transaction }
    public struct Input: DTO { public let id: String; public init(id: String) { self.id = id } }
    public func execute(_ input: Input) async throws -> ContactFormDetail {
        try await transaction.run { context in
            guard let value = try await context.form.findBy(id: input.id) else { throw Error.notFound }
            let items = try await context.item.listBy(formId: input.id).map(\.asDetail)
            let mails = try await context.mail.listBy(formId: input.id).map(\.asDetail)
            return value.asDetail(items: items, mails: mails)
        }
    }
    public enum Error: UseCaseError { case notFound }
}
