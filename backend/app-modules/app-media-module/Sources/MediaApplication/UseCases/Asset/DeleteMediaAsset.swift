import Application
import MediaDomain

public struct DeleteMediaAsset: UseCase {
    struct Action: PermissionAction {
        let key = MediaPermissions.Assets.delete
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

        public init(id: String) {
            self.id = id
        }
    }

    public func execute(
        subject: Subject,
        input: Input
    ) async throws -> Bool {
        let action = Action()
        guard try await authorizer.can(subject: subject, perform: action) else {
            throw AuthError(kind: .forbidden, message: action.key.rawValue)
        }

        return try await transaction.run { context in
            guard let asset = try await context.assets.find(id: input.id) else {
                return false
            }
            try await adjustFolderAggregates(
                folders: context.folders,
                folderId: asset.folderId,
                sizeDelta: -asset.sizeBytes,
                assetCountDelta: -1
            )
            try await context.processorAssets.deleteAll(assetId: asset.id)
            return try await context.assets.delete(id: input.id)
        }
    }
}

private extension DeleteMediaAsset {
    func adjustFolderAggregates(
        folders: any MediaFolderRepository,
        folderId: String?,
        sizeDelta: Int64,
        assetCountDelta: Int
    ) async throws {
        guard let folderId else { return }
        var current = try await folders.find(id: folderId)
        while let folder = current {
            var updated = folder
            updated.assetCount += assetCountDelta
            updated.totalSizeBytes += sizeDelta
            _ = try await folders.update(updated)
            guard let parentId = folder.parentId else {
                current = nil
                continue
            }
            current = try await folders.find(id: parentId)
        }
    }
}
