public import FeatherApplication
public import FeatherContracts
import MediaContracts

public struct ResolveMediaAssets: UseCase {
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
        public let ids: [String]
        public let variants: [String]?

        public init(
            ids: [String],
            variants: [String]?
        ) {
            self.ids = ids
            self.variants = variants
        }
    }

    public func execute(
        subject: Subject,
        input: Input
    ) async throws -> MediaAssetResolve {
        let action = Action()
        guard try await authorizer.can(subject: subject, perform: action) else {
            throw AuthError(kind: .forbidden, message: action.key.rawValue)
        }

        return try await query.run { scope in
            try await scope.assets.resolve(
                ids: input.ids,
                variants: input.variants
            )
        }
    }
}
