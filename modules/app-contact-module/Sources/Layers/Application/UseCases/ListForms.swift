import ContactContracts
import ContactDomain
import FeatherApplication
import FeatherContracts

public struct ListForms: UseCase {
    struct Action: PermissionAction {
        let key = ContactPermissions.Forms.list
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
    ) async throws -> [FormDetail] {
        let action = Action()
        guard try await authorizer.can(subject: subject, perform: action) else {
            throw AuthError(kind: .forbidden, message: action.key.rawValue)
        }
        return try await transaction.run { scope in
            try await scope.form.list().map(\.asDetail)
        }
    }
}
