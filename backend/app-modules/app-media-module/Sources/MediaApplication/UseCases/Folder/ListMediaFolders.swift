import Application
import MediaDomain

public struct ListMediaFolders: UseCase {
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
        public let query: MediaFolderList.Query

        public init(query: MediaFolderList.Query) {
            self.query = query
        }
    }

    public func execute(
        subject: Subject,
        input: Input
    ) async throws -> MediaFolderList {
        let action = Action()
        guard try await authorizer.can(subject: subject, perform: action) else {
            throw AuthError(kind: .forbidden, message: action.key.rawValue)
        }

        return try await query.run { scope in
            try await scope.folders.list(query: input.query)
        }
    }
}
