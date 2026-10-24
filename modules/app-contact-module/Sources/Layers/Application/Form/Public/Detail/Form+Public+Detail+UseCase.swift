import ContactDomain
public import ContactModule
public import FeatherApplication
public import FeatherModuleKit

extension Form.Public.Detail {
    public struct UseCase: FeatherApplication.UseCase {
        let transaction: any TransactionExecutor<Scope>

        public init(transaction: any TransactionExecutor<Scope>) {
            self.transaction = transaction
        }

        public func execute(input: Input) async throws -> Output {
            try await transaction.run { scope in
                guard let value = try await scope.form.findBy(key: input.key)
                else {
                    throw Error.formNotFound
                }
                let fields = try await scope.field.listBy(formId: value.id)
                    .map(\.asFormField)
                let mails = try await scope.mail.listBy(formId: value.id)
                    .map(\.asFormMail)
                return .init(
                    id: value.id,
                    key: value.key,
                    name: value.name,
                    successMessage: value.successMessage,
                    failureMessage: value.failureMessage,
                    redirectUrl: value.redirectUrl,
                    fields: fields,
                    mails: mails,
                    createdAt: value.createdAt,
                    updatedAt: value.updatedAt
                )
            }
        }
    }
}
