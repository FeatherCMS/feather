import AuthContracts
import AuthDomain
import FeatherApplication
import FeatherContracts

public struct RemoveCredential: UseCase {
    struct Action: PermissionAction {
        let key = AuthPermissions.Credential.delete
    }

    let authorizer: any Authorizer
    let transaction: any TransactionExecutor<WriteCredentialLink>

    public init(
        authorizer: any Authorizer,
        transaction: any TransactionExecutor<WriteCredentialLink>
    ) {
        self.authorizer = authorizer
        self.transaction = transaction
    }

    public struct Input: DTO {
        public let ids: [String]

        public init(ids: [String]) {
            self.ids = ids
        }
    }

    public func execute(
        subject: Subject,
        input: Input
    ) async throws -> Bool {
        let action = Action()

        guard try await authorizer.can(subject: subject, perform: action) else {
            throw AuthError(kind: .forbidden, message: action.key.rawValue)
        }

        return try await transaction.run { scope in
            try await scope.credential.delete(ids: input.ids)
        }
    }
}
