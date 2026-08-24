import AuthContracts
import AuthDomain
import FeatherApplication
import FeatherContracts

public struct GetCredential: UseCase {
    struct Action: PermissionAction {
        let key = AuthPermissions.Credential.read
    }

    let authorizer: any Authorizer
    let query: any QueryExecutor<ReadCredentialLink>

    public init(
        authorizer: any Authorizer,
        query: any QueryExecutor<ReadCredentialLink>
    ) {
        self.authorizer = authorizer
        self.query = query
    }

    public struct Input: DTO {
        public let id: String

        public init(
            id: String
        ) {
            self.id = id
        }
    }

    public func execute(
        subject: Subject,
        input: Input
    ) async throws -> CredentialDetail {
        let action = Action()

        guard try await authorizer.can(subject: subject, perform: action) else {
            throw AuthError(kind: .forbidden, message: action.key.rawValue)
        }

        return try await query.run { scope in
            try await scope.credential.find(id: input.id)
        }
    }
}
