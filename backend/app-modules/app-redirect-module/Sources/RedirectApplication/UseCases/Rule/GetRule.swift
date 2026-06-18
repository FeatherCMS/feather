import Application
import Domain
import RedirectDomain

public struct GetRule: UseCase {
    struct Action: PermissionAction {
        let key = RedirectPermissions.Rules.read
    }

    let authorizer: any Authorizer
    let query: any QueryExecutor<ReadRule>

    public init(
        authorizer: any Authorizer,
        query: any QueryExecutor<ReadRule>
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
    ) async throws -> RuleDetail {
        let action = Action()

        guard try await authorizer.can(subject: subject, perform: action) else {
            throw AuthError(kind: .forbidden, message: action.key.rawValue)
        }

        let id = input.id

        return try await query.run { context in
            try await context.rule.find(id: id)
        }
    }
}
