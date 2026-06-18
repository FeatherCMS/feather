import AnalyticsApplication
import Application
import RedirectApplication

struct GetRedirectNotFoundOverview: UseCase {

    struct Action: PermissionAction {
        let key = RedirectPermissions.NotFound.list
    }

    let authorizer: any Authorizer
    let query: any QueryExecutor<ReadLog>

    struct Input: DTO {
        let query: LogOverview.Query
    }

    func execute(
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
