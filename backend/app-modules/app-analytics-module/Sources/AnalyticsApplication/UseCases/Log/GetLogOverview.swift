import Application
import Domain

public struct GetLogOverview: UseCase {

    struct Action: PermissionAction {
        let key = AnalyticsPermissions.Insights.list
    }

    let authorizer: any Authorizer
    let query: any QueryExecutor<ReadLog>

    public init(
        authorizer: any Authorizer,
        query: any QueryExecutor<ReadLog>
    ) {
        self.authorizer = authorizer
        self.query = query
    }

    public struct Input: DTO {
        public let query: LogOverview.Query

        public init(query: LogOverview.Query) {
            self.query = query
        }
    }

    public func execute(
        subject: Subject,
        input: Input
    ) async throws -> LogOverview {
        let action = Action()
        guard try await authorizer.can(subject: subject, perform: action) else {
            throw AuthError(kind: .forbidden, message: action.key.rawValue)
        }
        return try await query.run { context in
            try await context.log.overview(query: input.query)
        }
    }
}
