import FeatherDBAL
import FeatherDomain
public import FeatherInfrastructure
public import MediaDomain
public import MediaModule

extension Asset.File.Variant.Table.Detail {
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

extension Asset.File.Variant.Table.List {
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
        private let accessLayer: DatabaseAccessLayer<Asset.File.Variant.Table>

        public init(context: DatabaseTransactionContext) {
            self.context = context
            self.accessLayer = .init(context: context)
        }

        public func insert(_ model: Asset.File.Variant.Model.New) async throws
            -> Asset.File.Variant.Model
        {
            let row = Asset.File.Variant.Table.Insert(
                id: context.idGenerator.generate(),
                assetNodeFileId: model.assetNodeFileId,
                variantId: model.variantId,
                variantProcessorId: model.variantProcessorId,
                storageObjectId: model.storageObjectId
            )
            try await accessLayer.insert(row)
            guard
                let saved = try await accessLayer.selectFirst(
                    by: \.id,
                    equals: row.id
                )
            else {
                throw RepositoryError.notFound
            }
            return saved.asDomain
        }

        public func insert(_ models: [Asset.File.Variant.Model.New])
            async throws
        {
            let rows = models.map {
                Asset.File.Variant.Table.Insert(
                    id: context.idGenerator.generate(),
                    assetNodeFileId: $0.assetNodeFileId,
                    variantId: $0.variantId,
                    variantProcessorId: $0.variantProcessorId,
                    storageObjectId: $0.storageObjectId
                )
            }
            try await accessLayer.insert(rows)
        }

        public func find(nodeId: String, variantId: String) async throws
            -> Asset.File.Variant.Model?
        {
            try await accessLayer.selectFirst(
                as: Asset.File.Variant.Table.Detail.self
            ) {
                $0.where(\.assetNodeFileId, equals: nodeId)
                    .where(\.variantId, equals: variantId)
            }
            .map(\.asDomain)
        }

        public func list(nodeId: String) async throws -> [Asset.File.Variant
            .Model]
        {
            try await list(nodeIds: [nodeId])
        }

        public func list(nodeIds: [String]) async throws -> [Asset.File.Variant
            .Model]
        {
            guard !nodeIds.isEmpty else { return [] }
            return
                try await accessLayer.select {
                    $0.where(\.assetNodeFileId, in: nodeIds)
                        .order(by: \.assetNodeFileId)
                        .order(by: \.createdAt)
                        .order(by: \.id)
                }
                .map(\.asDomain)
        }

        public func deleteAll(nodeId: String) async throws {
            try await accessLayer.delete(
                where: \.assetNodeFileId,
                equals: nodeId
            )
        }

        public func deleteAll(nodeIds: [String]) async throws {
            try await accessLayer.delete(where: \.assetNodeFileId, in: nodeIds)
        }
    }
}
