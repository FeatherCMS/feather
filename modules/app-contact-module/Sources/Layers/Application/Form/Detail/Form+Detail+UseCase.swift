import ContactDomain
public import ContactModule
public import FeatherApplication
public import FeatherModuleKit

extension Form.Detail {
    public struct UseCase: FeatherApplication.UseCase {
        let authorizer: any Authorizer
        let transaction: any TransactionExecutor<Scope>

        public init(
            authorizer: any Authorizer,
            transaction: any TransactionExecutor<Scope>
        ) {
            self.authorizer = authorizer
            self.transaction = transaction
        }

        public func execute(
            subject: Subject,
            input: Input
        ) async throws -> Output {
            let action = Action()
            guard try await authorizer.can(subject: subject, perform: action)
            else {
                throw AuthError(kind: .forbidden, message: action.key.rawValue)
            }
            let mailAction = MailListAction()
            guard
                try await authorizer.can(
                    subject: subject,
                    perform: mailAction
                )
            else {
                throw AuthError(
                    kind: .forbidden,
                    message: mailAction.key.rawValue
                )
            }
            return try await transaction.run { scope in
                guard let value = try await scope.form.findBy(key: input.key)
                else {
                    throw Error.formNotFound
                }
                let fields = try await scope.field.listBy(formId: value.id)
                    .map(\.asFormField)
                let mails = try await scope.mail.listBy(formId: value.id)
                    .map(\.asFormMail)
                return value.asDetail(fields: fields, mails: mails)
            }
        }
    }
}
