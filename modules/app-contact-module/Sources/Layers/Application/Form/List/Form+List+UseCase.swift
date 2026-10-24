import ContactDomain
public import ContactModule
public import FeatherApplication
public import FeatherModuleKit

extension Form.List {
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
            return try await transaction.run { scope in
                let forms = try await scope.form.list()
                var items: [Output.Item] = []
                for form in forms {
                    let fields = try await scope.field.listBy(formId: form.id)
                        .map(\.asFormField)
                    let mails = try await scope.mail.listBy(formId: form.id)
                        .map(\.asFormMail)
                    items.append(
                        .init(model: form, fields: fields, mails: mails)
                    )
                }
                return .init(items: items)
            }
        }
    }
}
