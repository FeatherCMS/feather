import ContactContracts
import ContactDomain
import FeatherApplication
import FeatherContracts

public struct DeleteFormField: UseCase {
    struct Error: UseCaseError { let message: String }
    struct Action: PermissionAction {
        let key = ContactPermissions.Fields.delete
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
        public let id: String
        public let formId: String?
        public init(id: String, formId: String?) {
            self.id = id
            self.formId = formId
        }
    }
    public func execute(
        subject: Subject,
        input: Input
    ) async throws {
        let action = Action()
        guard try await authorizer.can(subject: subject, perform: action) else {
            throw AuthError(kind: .forbidden, message: action.key.rawValue)
        }
        return try await transaction.run { scope in
            guard
                try await scope.field.delete(
                    id: input.id,
                    formId: input.formId
                )
            else {
                throw Error(message: "Contact form field not found")
            }
        }
    }
}
