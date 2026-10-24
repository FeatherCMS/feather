import FeatherApplication
import FeatherDatabase
import FeatherInfrastructure
import FeatherModuleKit
import FeatherStorage
import Foundation
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
    public func readOriginalAssetFile(assetId: String) async throws
        -> OriginalAssetFile
    {
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
        return .init(
            data: data,
            contentType: asset.contentType,
            filename: "\(asset.name).\(asset.extension)",
            slugPath: asset.slugPath
        )
    }
    public func readVariantFile(assetId: String, variantName: String)
        async throws -> VariantAssetFile
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
            return StoredVariantFile(
                relation: value,
                definition: definition,
                object: object
            )
        }
        let objectKey = try StorageObject.Model.storageKey(
            assetID: assetId,
            key: stored.object.key,
            extension: stored.object.extension,
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
        return .init(
            data: data,
            contentType: stored.object.contentType,
            filename: "\(stored.definition.key).\(stored.object.extension)"
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
            let definitions = try await Variant.Repository
                .Database(
                    context: .init(
                        platform: databaseContext.platform,
                        connection: connection,
                        idGenerator: databaseContext.idGenerator
                    )
                )
                .list()
            var variantDefinitions: [String: Variant.Model] = [:]
            for definition in definitions {
                precondition(
                    variantDefinitions.updateValue(
                        definition,
                        forKey: definition.id
                    ) == nil
                )
            }
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
            var objectsByID: [String: StorageObject.Model] = [:]
            for object in objects {
                precondition(
                    objectsByID.updateValue(object, forKey: object.id) == nil
                )
            }
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
