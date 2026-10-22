import ContactDomain
public import ContactModule
public import FeatherApplication
public import FeatherModuleKit

public struct ListForms: UseCase {
    struct Action: PermissionAction {
        let key = Form.Permissions.list
    }

    let authorizer: any Authorizer
    let transaction: any TransactionExecutor<WriteForm>
    public init(
        authorizer: any Authorizer,
        transaction: any TransactionExecutor<WriteForm>
    ) {
        self.authorizer = authorizer
        self.transaction = transaction
    }
    public struct Input: DTO { public init() {} }
    public func execute(
        subject: Subject,
        input: Input
    ) async throws -> Form.List.Output {
        let action = Action()
        guard try await authorizer.can(subject: subject, perform: action) else {
            throw AuthError(kind: .forbidden, message: action.key.rawValue)
        }
        return try await transaction.run { scope in
            let forms = try await scope.form.list()
            var items: [Form.List.Output.Item] = []
            for form in forms {
                let fields = try await scope.field.listBy(formId: form.id)
                    .map(\.asFormField)
                let mails = try await scope.mail.listBy(formId: form.id)
                    .map(\.asFormMail)
                items.append(.init(model: form, fields: fields, mails: mails))
            }
            return .init(items: items)
        }
    }
}
