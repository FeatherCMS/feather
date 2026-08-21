import FeatherApplication
import FeatherContracts
import SystemContracts
import SystemDomain

public struct ListJobs: UseCase {
    struct Action: PermissionAction {
        let key = SystemPermissions.Jobs.list
    }

    let authorizer: any Authorizer
    let query: any QueryExecutor<ReadJob>

    public init(
        authorizer: any Authorizer,
        query: any QueryExecutor<ReadJob>
    ) {
        self.authorizer = authorizer
        self.query = query
    }

    public func execute(
        subject: Subject
    ) async throws -> [JobDetail] {
        let action = Action()
        guard try await authorizer.can(subject: subject, perform: action) else {
            throw AuthError(kind: .forbidden, message: action.key.rawValue)
        }
        return try await query.run { scope in
            try await scope.job.list()
        }
    }
}
