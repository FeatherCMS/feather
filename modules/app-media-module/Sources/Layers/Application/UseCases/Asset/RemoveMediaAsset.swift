import FeatherApplication
import FeatherContracts
import MediaContracts
import MediaDomain

//
//  RemoveMediaAsset.swift
//  app-media-module
//
//  Created by Binary Birds on 2026. 06. 18.

public struct RemoveMediaAsset: UseCase {
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
        public let ids: [String]

        public init(ids: [String]) { self.ids = ids }
    }

    public func execute(
        subject: Subject,
        input: Input
    ) async throws -> [String] {
        let action = Action()
        guard try await authorizer.can(subject: subject, perform: action) else {
            throw AuthError(kind: .forbidden, message: action.key.rawValue)
        }

        let snapshot = try await transaction.run { scope in
            var assetsById: [String: MediaAsset] = [:]
            var foldersById: [String: MediaFolder] = [:]
            for id in input.ids {
                if let asset = try await scope.assets.find(id: id) {
                    assetsById[asset.id] = asset
                    continue
                }
                if let folder = try await scope.folders.find(id: id) {
                    for descendant in try await scope.folders.listDescendants(
                        path: folder.path
                    ) {
                        foldersById[descendant.id] = descendant
                    }
                }
            }
            let folderIds = Array(foldersById.keys)
            let folderAssets = try await scope.assets.list(
                folderIds: folderIds
            )
            for asset in folderAssets {
                assetsById[asset.id] = asset
            }
            return RemoveSnapshot(
                assets: Array(assetsById.values),
                folders: Array(foldersById.values)
            )
        }

        for asset in snapshot.assets {
            for key in originalStorageKeys(for: asset) {
                _ = try? await storage.delete(key: key)
            }
            for variant in (try? await listVariants(assetId: asset.id)) ?? [] {
                _ = try? await storage.delete(key: variant.storageKey)
            }
        }

        return try await transaction.run { scope in
            for asset in snapshot.assets {
                try await adjustFolderAggregates(
                    folders: scope.folders,
                    folderId: asset.folderId,
                    sizeDelta: -asset.sizeBytes,
                    assetCountDelta: -1
                )
                try await scope.processorAssets.deleteAll(assetId: asset.id)
            }
            let deletedAssetIds = try await scope.assets.delete(
                ids: snapshot.assets.map(\.id)
            )
            let deletedFolderIds = try await scope.folders.delete(
                ids: snapshot.folders.map(\.id)
            )
            return deletedFolderIds + deletedAssetIds
        }
    }
}

extension RemoveMediaAsset {
    private struct VariantSnapshot: Sendable {
        let storageKey: String
    }

    private func listVariants(
        assetId: String
    ) async throws -> [VariantSnapshot] {
        try await transaction.run { scope in
            try await scope.processorAssets.list(assetId: assetId)
                .map { .init(storageKey: $0.storageKey) }
        }
    }

    fileprivate func adjustFolderAggregates(
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

private struct RemoveSnapshot: Sendable {
    let assets: [MediaAsset]
    let folders: [MediaFolder]
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
