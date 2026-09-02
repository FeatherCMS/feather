import ContactContracts
import ContactDomain
import FeatherApplication
import FeatherContracts

public struct DeleteSubmission: UseCase {
    struct Action: PermissionAction {
        let key = ContactPermissions.Submissions.delete
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
        public let ids: [String]

        public init(ids: [String]) { self.ids = ids }
    }

    public func execute(
        subject: Subject,
        input: Input
    ) async throws -> [String] {
        let action = Action()
        guard try await authorizer.can(subject: subject, perform: action) else {
            throw AuthError(kind: .forbidden, message: action.key.rawValue)
        }
        return try await transaction.run { scope in
            try await scope.submission.delete(ids: input.ids)
        }
    }
}
