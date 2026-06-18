import Application
import MediaDomain

public struct GetMediaFolder: UseCase {
    struct Action: PermissionAction {
        let key = MediaPermissions.Assets.list
    }

    let authorizer: any Authorizer
    let query: any QueryExecutor<ReadMedia>

    public init(
        authorizer: any Authorizer,
        query: any QueryExecutor<ReadMedia>
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
    ) async throws -> MediaFolderDetail {
        let action = Action()
        guard try await authorizer.can(subject: subject, perform: action) else {
            throw AuthError(kind: .forbidden, message: action.key.rawValue)
        }

        return try await query.run { scope in
            try await scope.folders.find(id: input.id)
        }
    }
}
