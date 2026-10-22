import FeatherDBAL
import FeatherDomain
public import FeatherInfrastructure
public import MediaDomain
public import MediaModule

extension Asset.File.Variant.Table.Row {
    var asDomain: Asset.File.Variant.Model {
        .init(
            id: id,
            assetNodeFileId: assetNodeFileId,
            variantId: variantId,
            variantProcessorId: variantProcessorId,
            storageObjectId: storageObjectId,
            createdAt: createdAt
        )
    }
}

extension Asset.File.Variant.Repository {
    public struct Database: Interface {
        public let context: DatabaseTransactionContext

        public init(context: DatabaseTransactionContext) {
            self.context = context
        }

        public func insert(_ model: Asset.File.Variant.Model.New) async throws
            -> Asset.File.Variant.Model
        {
            let row = try await Asset.File.Variant
                .Table(
                    connection: context.connection
                )
                .create(
                    row: .init(
                        id: context.idGenerator.generate(),
                        assetNodeFileId: model.assetNodeFileId,
                        variantId: model.variantId,
                        variantProcessorId: model.variantProcessorId,
                        storageObjectId: model.storageObjectId
                    )
                )
            return row.asDomain
        }

        public func insert(_ models: [Asset.File.Variant.Model.New])
            async throws
        {
            guard !models.isEmpty else { return }
            let rows = models.map {
                Asset.File.Variant.Table.Row.Create(
                    id: context.idGenerator.generate(),
                    assetNodeFileId: $0.assetNodeFileId,
                    variantId: $0.variantId,
                    variantProcessorId: $0.variantProcessorId,
                    storageObjectId: $0.storageObjectId
                )
            }
            try await Asset.File.Variant.Table(connection: context.connection)
                .create(rows: rows)
        }

        public func find(nodeId: String, variantId: String) async throws
            -> Asset.File.Variant.Model?
        {
            try await Asset.File.Variant.Table(connection: context.connection)
                .find(nodeId: nodeId, variantId: variantId)?
                .asDomain
        }

        public func list(nodeId: String) async throws -> [Asset.File.Variant
            .Model]
        {
            try await Asset.File.Variant.Table(connection: context.connection)
                .list(nodeId: nodeId)
                .map(\.asDomain)
        }

        public func list(nodeIds: [String]) async throws
            -> [Asset.File.Variant.Model]
        {
            try await Asset.File.Variant.Table(connection: context.connection)
                .list(nodeIds: nodeIds)
                .map(\.asDomain)
        }

        public func deleteAll(nodeId: String) async throws {
            try await Asset.File.Variant.Table(connection: context.connection)
                .deleteAll(nodeId: nodeId)
        }

        public func deleteAll(nodeIds: [String]) async throws {
            try await Asset.File.Variant.Table(connection: context.connection)
                .deleteAll(nodeIds: nodeIds)
        }
    }
}
