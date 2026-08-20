import SystemContracts
import FeatherApplication
import FeatherContracts
import SystemDomain

public struct GetJob: UseCase {
    struct Action: PermissionAction {
        let key = SystemPermissions.Jobs.read
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

    public struct Input: DTO {
        public let id: String

        public init(id: String) {
            self.id = id
        }
    }

    public func execute(
        subject: Subject,
        input: Input
    ) async throws -> JobDetail {
        let action = Action()
        guard try await authorizer.can(subject: subject, perform: action) else {
            throw AuthError(kind: .forbidden, message: action.key.rawValue)
        }
        return try await query.run { scope in
            try await scope.job.find(id: input.id)
        }
    }
}
