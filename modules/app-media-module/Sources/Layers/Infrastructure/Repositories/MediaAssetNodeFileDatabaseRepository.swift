import FeatherDatabase
import FeatherDomain
import FeatherInfrastructure
import MediaDomain

extension MediaAssetNodeFileTable.Row {
    var asDomain: MediaAssetNodeFile {
        .init(
            id: id,
            folderId: folderId,
            name: name,
            slug: slug,
            slugPath: slugPath,
            storageObjectId: storageObjectId,
            objectKey: objectKey,
            extension: `extension`,
            contentType: contentType,
            sizeBytes: sizeBytes,
            status: .init(rawValue: status) ?? .uploaded,
            title: title,
            altText: altText,
            createdAt: createdAt,
            updatedAt: updatedAt,
            deletedAt: deletedAt
        )
    }
}

public struct MediaAssetNodeFileDatabaseRepository: MediaAssetNodeFileRepository {
    public let context: DatabaseTransactionContext

    public init(context: DatabaseTransactionContext) {
        self.context = context
    }

    public func prepareStorageIdentity() -> MediaAssetNodeFileStorageIdentity {
        .init(nodeId: context.idGenerator.generate())
    }

    public func insert(
        _ model: MediaAssetNodeFile.New,
        storageIdentity: MediaAssetNodeFileStorageIdentity,
        storageObjectId: String
    ) async throws -> MediaAssetNodeFile {
        let row = try await MediaAssetNodeFileTable(connection: context.connection)
            .create(
                row: .init(
                    id: storageIdentity.nodeId,
                    folderId: model.folderId,
                    name: model.name,
                    slug: model.slug,
                    slugPath: model.slugPath,
                    storageObjectId: storageObjectId,
                    extension: model.extension,
                    contentType: model.contentType,
                    sizeBytes: model.sizeBytes,
                    status: model.status.rawValue,
                    title: model.title,
                    altText: model.altText
                )
            )
        return row.asDomain
    }

    public func update(_ model: MediaAssetNodeFile) async throws -> MediaAssetNodeFile {
        let row = try await MediaAssetNodeFileTable(connection: context.connection)
            .update(
                row: .init(
                    id: model.id,
                    folderId: model.folderId,
                    name: model.name,
                    slug: model.slug,
                    slugPath: model.slugPath,
                    storageObjectId: model.storageObjectId,
                    objectKey: model.objectKey,
                    extension: model.extension,
                    contentType: model.contentType,
                    sizeBytes: model.sizeBytes,
                    status: model.status.rawValue,
                    title: model.title,
                    altText: model.altText,
                    createdAt: model.createdAt,
                    updatedAt: model.updatedAt,
                    deletedAt: model.deletedAt
                )
            )
        return row.asDomain
    }

    public func find(id: String) async throws -> MediaAssetNodeFile? {
        try await MediaAssetNodeFileTable(connection: context.connection).find(id: id)?.asDomain
    }

    public func list(folderIds: [String]) async throws -> [MediaAssetNodeFile] {
        try await MediaAssetNodeFileTable(connection: context.connection)
            .list(folderIds: folderIds)
            .map(\.asDomain)
    }

    public func delete(ids: [String]) async throws -> [String] {
        try await MediaAssetNodeFileTable(connection: context.connection).delete(ids: ids)
    }
}
