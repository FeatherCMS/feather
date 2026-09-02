import FeatherApplication
import FeatherContracts
import MediaContracts
import MediaDomain

//
//  DeleteMediaAsset.swift
//  app-media-module
//
//  Created by Binary Birds on 2026. 06. 18.

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
        public let ids: [String]

        public init(ids: [String]) { self.ids = ids }
    }

    public func execute(
        subject: Subject,
        input: Input
    ) async throws -> Bool {
        let action = Action()
        guard try await authorizer.can(subject: subject, perform: action) else {
            throw AuthError(kind: .forbidden, message: action.key.rawValue)
        }

        return try await transaction.run { scope in
            var removed = true
            for id in input.ids {
                guard let asset = try await scope.assets.find(id: id) else {
                    removed = false
                    continue
                }
            try await adjustFolderAggregates(
                folders: scope.folders,
                folderId: asset.folderId,
                sizeDelta: -asset.sizeBytes,
                assetCountDelta: -1
            )
            try await scope.processorAssets.deleteAll(assetId: asset.id)
                removed = try await scope.assets.delete(ids: [id]) && removed
            }
            return removed
        }
    }
}

extension DeleteMediaAsset {
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
