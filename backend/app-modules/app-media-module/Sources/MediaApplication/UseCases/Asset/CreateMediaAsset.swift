import Application
import Foundation
import MediaDomain

public struct CreateMediaAsset: UseCase {
    struct Action: PermissionAction {
        let key = MediaPermissions.Assets.create
    }

    let authorizer: any Authorizer
    let transaction: any TransactionExecutor<WriteMedia>
    let idGenerator: any IDGenerator
    let storage: any MediaStorage

    public init(
        authorizer: any Authorizer,
        transaction: any TransactionExecutor<WriteMedia>,
        idGenerator: any IDGenerator,
        storage: any MediaStorage
    ) {
        self.authorizer = authorizer
        self.transaction = transaction
        self.idGenerator = idGenerator
        self.storage = storage
    }

    public struct Input: DTO {
        public let folderId: String?
        public let storageKey: String
        public let type: String
        public let title: String?
        public let altText: String?
        public let data: Data

        public init(
            folderId: String? = nil,
            storageKey: String,
            type: String,
            title: String? = nil,
            altText: String? = nil,
            data: Data
        ) {
            self.folderId = folderId
            self.storageKey = storageKey
            self.type = type
            self.title = title
            self.altText = altText
            self.data = data
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

        let objectKey = input.storageKey
        try await storage.upload(key: objectKey, data: input.data)

        do {
            let model = try await transaction.run { context in
                let asset = try await context.assets.insert(
                    MediaAsset.create(
                        id: idGenerator.generate(),
                        folderId: input.folderId,
                        storageKey: input.storageKey,
                        type: input.type,
                        sizeBytes: Int64(input.data.count),
                        title: input.title,
                        altText: input.altText
                    )
                )
                try await adjustFolderAggregates(
                    folders: context.folders,
                    folderId: input.folderId,
                    sizeDelta: Int64(input.data.count),
                    assetCountDelta: 1
                )
                return asset
            }
            return model.asDetail
        }
        catch {
            _ = try? await storage.delete(key: objectKey)
            throw error
        }
    }
}

private extension CreateMediaAsset {
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
