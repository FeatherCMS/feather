import Application
import MediaDomain

public struct DeleteMediaFolder: UseCase {
    public enum Error: UseCaseError {
        case folderNotFound
    }

    struct Action: PermissionAction {
        let key = MediaPermissions.Assets.delete
    }

    let authorizer: any Authorizer
    let transaction: any TransactionExecutor<WriteMedia>
    let storage: any MediaStorage

    public init(
        authorizer: any Authorizer,
        transaction: any TransactionExecutor<WriteMedia>,
        storage: any MediaStorage
    ) {
        self.authorizer = authorizer
        self.transaction = transaction
        self.storage = storage
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

        let snapshot: FolderDeleteSnapshot? = try await transaction.run {
            context in
            guard let folder = try await context.folders.find(id: input.id)
            else {
                return nil
            }
            let descendants = try await context.folders.listDescendants(
                path: folder.path
            )
            let folderIds = descendants.map(\.id)
            let assets = try await context.assets.list(folderIds: folderIds)
            var variantsByAssetId: [String: [MediaProcessorAsset]] = [:]
            for asset in assets {
                variantsByAssetId[asset.id] = try await context.processorAssets
                    .list(assetId: asset.id)
            }
            return FolderDeleteSnapshot(
                folders: descendants,
                assets: assets,
                variantsByAssetId: variantsByAssetId
            )
        }

        guard let snapshot else { return false }

        for asset in snapshot.assets {
            for candidate in originalStorageKeys(for: asset) {
                _ = try? await storage.delete(key: candidate)
            }
            for variant in snapshot.variantsByAssetId[asset.id] ?? [] {
                _ = try? await storage.delete(key: variant.storageKey)
            }
        }

        return try await transaction.run { context in
            for asset in snapshot.assets {
                try await context.processorAssets.deleteAll(assetId: asset.id)
                _ = try await context.assets.delete(id: asset.id)
            }

            for folder in snapshot.folders.sorted(by: deeperPathFirst) {
                _ = try await context.folders.delete(id: folder.id)
            }
            return true
        }
    }
}

private struct FolderDeleteSnapshot: Sendable {
    let folders: [MediaFolder]
    let assets: [MediaAsset]
    let variantsByAssetId: [String: [MediaProcessorAsset]]
}

private func deeperPathFirst(
    _ lhs: MediaFolder,
    _ rhs: MediaFolder
) -> Bool {
    lhs.path.count > rhs.path.count
}

private func originalStorageKeys(
    for asset: MediaAsset
) -> [String] {
    var keys: [String] = [asset.storageKey]
    if MediaExtensionMatcher.storageKeyExtension(asset.storageKey) == nil,
        let ext = MediaExtensionMatcher.canonicalExtension(from: asset.type)
    {
        keys.append("\(asset.storageKey).\(ext)")
    }
    return keys
}
