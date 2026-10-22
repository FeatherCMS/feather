import ContactContracts
public import ContactDomain
import ContactModule
public import FeatherApplication
public import FeatherModuleKit

public struct ListFormFields: UseCase {
    struct Action: PermissionAction {
        let key = ContactModule.Permissions.Fields.list
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
    public struct Input: DTO {
        public let formId: String?
        public let formKey: String?
        public init(formId: String?, formKey: String? = nil) {
            self.formId = formId
            self.formKey = formKey
        }
    }
    public func execute(
        subject: Subject,
        input: Input
    ) async throws -> [FormField.Detail.Output] {
        let action = Action()
        guard try await authorizer.can(subject: subject, perform: action) else {
            throw AuthError(kind: .forbidden, message: action.key.rawValue)
        }
        return try await transaction.run { scope in
            if input.formKey == FormFieldListFilter.unassigned {
                return try await scope.field.listUnassigned().map(\.asDetail)
            }
            if let formKey = input.formKey {
                guard let form = try await scope.form.findBy(key: formKey)
                else {
                    return []
                }
                return try await scope.field.listBy(formId: form.id)
                    .map(\.asDetail)
            }
            return try await scope.field.listBy(formId: input.formId)
                .map(\.asDetail)
        }
    }
}
