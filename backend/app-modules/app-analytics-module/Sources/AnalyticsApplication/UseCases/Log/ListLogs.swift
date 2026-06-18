import AnalyticsDomain
import Application
import Domain

public struct ListLogs: UseCase {

    struct Action: PermissionAction {
        let key = AnalyticsPermissions.Logs.list
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
        public let query: LogList.Query

        public init(query: LogList.Query) {
            self.query = query
        }
    }

    public func execute(
        subject: Subject,
        input: Input
    ) async throws -> LogList {
        let action = Action()
        guard try await authorizer.can(subject: subject, perform: action) else {
            throw AuthError(kind: .forbidden, message: action.key.rawValue)
        }
        let objectQuery = input.query
        return try await query.run { context in
            try await context.log.list(query: objectQuery)
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
        let objectQuery = input.query
        return try await query.run { context in
            try await context.log.count(query: objectQuery)
        }
    }
}
