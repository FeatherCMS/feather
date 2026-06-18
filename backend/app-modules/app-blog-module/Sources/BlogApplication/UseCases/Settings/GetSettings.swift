import Application
import BlogDomain
import Domain

public struct GetSettings: UseCase {
    struct Action: PermissionAction {
        let key = BlogPermissions.Settings.read
    }

    let authorizer: any Authorizer
    let query: any QueryExecutor<ReadSettings>

    public init(
        authorizer: any Authorizer,
        query: any QueryExecutor<ReadSettings>
    ) {
        self.authorizer = authorizer
        self.query = query
    }

    public struct Input: DTO {
        public init() {}
    }

    public func execute(
        subject: Subject,
        input: Input
    ) async throws -> SettingsDetail {
        let action = Action()

        guard try await authorizer.can(subject: subject, perform: action) else {
            throw AuthError(kind: .forbidden, message: action.key.rawValue)
        }

        return try await query.run { context in
            try await context.settings.get()
        }
    }
}
