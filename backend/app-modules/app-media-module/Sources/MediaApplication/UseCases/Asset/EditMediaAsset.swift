import Application
import MediaDomain

public struct EditMediaAsset: UseCase {
    struct Action: PermissionAction {
        let key = MediaPermissions.Assets.update
    }

    struct Error: UseCaseError {
        let message: String
    }

    let authorizer: any Authorizer
    let transaction: any TransactionExecutor<WriteMedia>

    public init(
        authorizer: any Authorizer,
        transaction: any TransactionExecutor<WriteMedia>
    ) {
        self.authorizer = authorizer
        self.transaction = transaction
    }

    public struct Input: DTO {
        public let id: String
        public let title: String?
        public let altText: String?

        public init(
            id: String,
            title: String?,
            altText: String?
        ) {
            self.id = id
            self.title = title
            self.altText = altText
        }
    }

    public func execute(
        subject: Subject,
        input: Input
    ) async throws -> MediaAssetDetail {
        let action = Action()
        guard try await authorizer.can(subject: subject, perform: action) else {
            throw AuthError(kind: .forbidden, message: action.key.rawValue)
        }

        return try await transaction.run { context in
            guard var asset = try await context.assets.find(id: input.id) else {
                throw Error(message: "Asset not found")
            }

            asset.title = input.title
            asset.altText = input.altText

            return try await context.assets.update(asset).asDetail
        }
    }
}
