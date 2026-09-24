public import FeatherApplication
public import FeatherContracts
public import FeatherStorage
import MediaContracts
import MediaDomain

public struct RemoveMediaAsset: UseCase {
    struct Action: PermissionAction { let key = MediaPermissions.Assets.delete }
    let authorizer: any Authorizer
    let transaction: any TransactionExecutor<WriteMedia>
    let storage: any StorageClient
    let storageKeyShard: MediaStorageKeyShard

    public init(
        authorizer: any Authorizer,
        transaction: any TransactionExecutor<WriteMedia>,
        storage: any StorageClient,
        storageKeyShard: MediaStorageKeyShard = .init()
    ) {
        self.authorizer = authorizer
        self.transaction = transaction
        self.storage = storage
        self.storageKeyShard = storageKeyShard
    }

    public struct Input: DTO {
        public let ids: [String]
        public init(ids: [String]) { self.ids = ids }
    }

    public func execute(subject: Subject, input: Input) async throws -> [String]
    {
        let action = Action()
        guard try await authorizer.can(subject: subject, perform: action) else {
            throw AuthError(kind: .forbidden, message: action.key.rawValue)
        }
        let snapshot = try await transaction.run { scope in
            var assets: [String: MediaAssetNodeFile] = [:]
            var folders: [String: MediaAssetNodeFolder] = [:]
            for id in input.ids {
                if let asset = try await scope.assets.find(id: id) {
                    assets[asset.id] = asset
                }
                if let folder = try await scope.folders.find(id: id) {
                    for descendant in try await scope.folders.listDescendants(
                        slugPath: folder.slugPath
                    ) { folders[descendant.id] = descendant }
                }
            }
            for asset in try await scope.assets.list(
                folderIds: Array(folders.keys)
            ) { assets[asset.id] = asset }
            var variants: [MediaAssetNodeFileVariant] = []
            for asset in assets.values {
                variants.append(
                    contentsOf: try await scope.variants.list(nodeId: asset.id)
                )
            }
            return Snapshot(
                assets: Array(assets.values),
                folders: Array(folders.values),
                variants: variants
            )
        }
        for asset in snapshot.assets {
            _ = try? await MediaStorageData.delete(
                from: storage,
                key: storageKeyShard.physicalKey(for: asset.objectKey)
            )
        }
        for variant in snapshot.variants {
            _ = try? await MediaStorageData.delete(
                from: storage,
                key: storageKeyShard.physicalKey(for: variant.objectKey)
            )
        }
        return try await transaction.run { scope in
            for asset in snapshot.assets {
                try await adjustFolderAggregates(
                    folders: scope.folders,
                    folderId: asset.folderId,
                    sizeDelta: -asset.sizeBytes,
                    assetCountDelta: -1
                )
                try await scope.variants.deleteAll(nodeId: asset.id)
            }
            let assetIds = try await scope.assets.delete(
                ids: snapshot.assets.map(\.id)
            )
            let folderIds = try await scope.folders.delete(
                ids: snapshot.folders.map(\.id)
            )
            _ = try await scope.storageObjects.delete(
                ids: snapshot.variants.map(\.storageObjectId)
                    + snapshot.assets.map(\.storageObjectId)
            )
            return folderIds + assetIds
        }
    }
}

extension RemoveMediaAsset {
    fileprivate struct Snapshot: Sendable {
        let assets: [MediaAssetNodeFile]
        let folders: [MediaAssetNodeFolder]
        let variants: [MediaAssetNodeFileVariant]
    }
    fileprivate func adjustFolderAggregates(
        folders: any MediaAssetNodeFolderRepository,
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
            if let parentId = folder.parentId {
                current = try await folders.find(id: parentId)
            }
            else {
                current = nil
            }
        }
    }
}
