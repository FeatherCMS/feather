import FeatherApplication
import FeatherContracts
import SystemContracts

public struct ResolveMetadata: UseCase {
    struct Action: PermissionAction {
        let key = SystemPermissions.Admin.access
    }

    let authorizer: any Authorizer
    let query: any QueryExecutor<ReadMetadata>

    public init(
        authorizer: any Authorizer,
        query: any QueryExecutor<ReadMetadata>
    ) {
        self.authorizer = authorizer
        self.query = query
    }

    public struct Input: DTO {
        public let referenceType: String
        public let referenceIDs: [String]

        public init(
            referenceType: String,
            referenceIDs: [String]
        ) {
            self.referenceType = referenceType
            self.referenceIDs = referenceIDs
        }
    }

    public func execute(
        subject: Subject,
        input: Input
    ) async throws -> [MetadataList.Item] {
        let action = Action()

        guard try await authorizer.can(subject: subject, perform: action) else {
            throw AuthError(kind: .forbidden, message: action.key.rawValue)
        }

        return try await query.run { scope in
            try await scope.metadata.resolve(
                referenceType: input.referenceType,
                referenceIDs: input.referenceIDs
            )
        }
    }
}
