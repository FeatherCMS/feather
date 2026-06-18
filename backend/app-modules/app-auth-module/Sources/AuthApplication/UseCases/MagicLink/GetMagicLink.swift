import Application
import AuthDomain

public struct GetMagicLink: UseCase {
    struct Action: PermissionAction {
        let key = AuthPermissions.MagicLinks.read
    }

    let authorizer: any Authorizer
    let query: any QueryExecutor<ReadMagicLink>

    public init(
        authorizer: any Authorizer,
        query: any QueryExecutor<ReadMagicLink>
    ) {
        self.authorizer = authorizer
        self.query = query
    }

    public struct Input: DTO {
        public let id: String

        public init(id: String) {
            self.id = id
        }
    }

    public func execute(
        subject: Subject,
        input: Input
    ) async throws -> MagicLinkDetail {
        let action = Action()

        guard try await authorizer.can(subject: subject, perform: action) else {
            throw AuthError(kind: .forbidden, message: action.key.rawValue)
        }

        return try await query.run { context in
            try await context.magicLink.find(id: input.id)
        }
    }
}
