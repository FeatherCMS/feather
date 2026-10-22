import FeatherApplication
import FeatherDatabase
import FeatherInfrastructure
import FeatherModuleKit
import FeatherStorage
public import Foundation
public import MediaApplication
import MediaDomain
import MediaInfrastructure
public import MediaModule
import NIOCore

extension UseCases {
    public func detailAsset(id: String) async throws
        -> Asset.File.Detail.Output
    {
        try await databaseContext.database.withConnection { connection in
            try await Asset.File.Detail.Query
                .Database(
                    context: .init(
                        platform: databaseContext.platform,
                        connection: connection,
                        idGenerator: databaseContext.idGenerator
                    ),
                    objectKeyGenerator: storageContext.objectKeyGenerator
                )
                .find(id: id)
        }
    }
    public func readOriginalAssetFile(assetId: String) async throws -> (
        data: Data, type: String, filename: String, slugPath: String
    ) {
        let asset = try await databaseContext.database.withConnection {
            connection in
            try await Asset.File.Detail.Query
                .Database(
                    context: .init(
                        platform: databaseContext.platform,
                        connection: connection,
                        idGenerator: databaseContext.idGenerator
                    ),
                    objectKeyGenerator: storageContext.objectKeyGenerator
                )
                .find(id: assetId)
        }
        let sequence = try await storageContext.storage.download(
            key: try StorageObject.Model.storageKey(
                assetID: asset.id,
                key: "original",
                extension: asset.extension,
                objectKeyGenerator: storageContext.objectKeyGenerator
            ),
            range: nil
        )
        var data = Data()
        for try await buffer in sequence {
            data.append(contentsOf: buffer.readableBytesView)
        }
        return (
            data,
            asset.contentType, "\(asset.name).\(asset.extension)",
            asset.slugPath
        )
    }
    public func readVariantFile(assetId: String, variantName: String)
        async throws -> (data: Data, type: String, filename: String)
    {
        let stored = try await databaseContext.database.withConnection {
            connection in
            let repo = Asset.File.Variant.Repository.Database(
                context: .init(
                    platform: databaseContext.platform,
                    connection: connection,
                    idGenerator: databaseContext.idGenerator
                )
            )
            let definitions = try await Variant.Repository
                .Database(
                    context: .init(
                        platform: databaseContext.platform,
                        connection: connection,
                        idGenerator: databaseContext.idGenerator
                    )
                )
                .list()
            guard
                let definition = definitions.first(where: {
                    $0.key == variantName
                }),
                let value = try await repo.list(nodeId: assetId)
                    .first(where: { $0.variantId == definition.id })
            else { throw RepositoryError.notFound }
            let objectRepository = StorageObject.Repository.Database(
                context: .init(
                    platform: databaseContext.platform,
                    connection: connection,
                    idGenerator: databaseContext.idGenerator
                )
            )
            guard
                let object = try await objectRepository.find(
                    storageObjectId: value.storageObjectId
                )
            else { throw RepositoryError.notFound }
            return (value, definition, object)
        }
        let objectKey = try StorageObject.Model.storageKey(
            assetID: assetId,
            key: stored.2.key,
            extension: stored.2.extension,
            objectKeyGenerator: storageContext.objectKeyGenerator
        )
        let sequence = try await storageContext.storage.download(
            key: objectKey,
            range: nil
        )
        var data = Data()
        for try await buffer in sequence {
            data.append(contentsOf: buffer.readableBytesView)
        }
        return (
            data,
            stored.2.contentType,
            "\(stored.1.key).\(stored.2.extension)"
        )
    }
    public func listAssociatedVariantFiles(assetId: String) async throws
        -> [AssociatedVariantFile]
    {
        try await databaseContext.database.withConnection { connection in
            let repo = Asset.File.Variant.Repository.Database(
                context: .init(
                    platform: databaseContext.platform,
                    connection: connection,
                    idGenerator: databaseContext.idGenerator
                )
            )
            let variantDefinitions = Dictionary(
                uniqueKeysWithValues: try await Variant.Repository
                    .Database(
                        context: .init(
                            platform: databaseContext.platform,
                            connection: connection,
                            idGenerator: databaseContext.idGenerator
                        )
                    )
                    .list()
                    .map { ($0.id, $0) }
            )
            guard
                let asset = try await Asset.File.Repository
                    .Database(
                        context: .init(
                            platform: databaseContext.platform,
                            connection: connection,
                            idGenerator: databaseContext.idGenerator
                        )
                    )
                    .find(id: assetId)
            else { throw RepositoryError.notFound }
            let objects = try await StorageObject.Repository
                .Database(
                    context: .init(
                        platform: databaseContext.platform,
                        connection: connection,
                        idGenerator: databaseContext.idGenerator
                    )
                )
                .list(assetNodeFileIds: [assetId])
            let objectsByID = Dictionary(
                uniqueKeysWithValues: objects.map { ($0.id, $0) }
            )
            return try await repo.list(nodeId: assetId)
                .compactMap { relation -> AssociatedVariantFile? in
                    guard
                        let definition = variantDefinitions[relation.variantId],
                        let object = objectsByID[relation.storageObjectId]
                    else { return nil }
                    return AssociatedVariantFile(
                        assetId: assetId,
                        slugPath: asset.slugPath,
                        filename: asset.name,
                        variantId: relation.variantId,
                        key: definition.key,
                        name: definition.name,
                        url: try mediaVariantPublicURL(
                            assetId: assetId,
                            slugPath: asset.slugPath,
                            filename: asset.name,
                            variantKey: definition.key,
                            extension: object.extension,
                            objectKeyGenerator: storageContext
                                .objectKeyGenerator
                        ),
                        extension: object.extension,
                        objectKey:
                            try StorageObject.Model.storageKey(
                                assetID: assetId,
                                key: object.key,
                                extension: object.extension,
                                objectKeyGenerator: storageContext
                                    .objectKeyGenerator
                            )
                    )
                }
        }
    }
}
