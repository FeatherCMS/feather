import Domain
import RedirectDomain
import Application

public struct ListRules: UseCase {
    struct Action: PermissionAction {
        let key = RedirectPermissions.Rules.list
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
        public let query: RuleList.Query

        public init(
            query: RuleList.Query
        ) {
            self.query = query
        }
    }

    public func execute(
        subject: Subject,
        input: Input
    ) async throws -> RuleList {
        let action = Action()

        guard try await authorizer.can(subject: subject, perform: action) else {
            throw AuthError(kind: .forbidden, message: action.key.rawValue)
        }

        let inputQuery = input.query

        return try await query.run { context in
            try await context.rule.list(
                query: inputQuery
            )
        }
    }

    public func count(
        subject: Subject,
        input: Input
    ) async throws -> Int {
        let action = Action()

        guard try await authorizer.can(subject: subject, perform: action) else {
            throw AuthError(kind: .forbidden, message: action.key.rawValue)
        }

        let inputQuery = input.query

        return try await query.run { context in
            try await context.rule.count(
                query: inputQuery
            )
        }
    }
}
