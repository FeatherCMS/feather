import FeatherDBAL
import FeatherDomain
public import FeatherInfrastructure
public import MediaDomain
public import MediaModule

extension Variant.Processor.Table.Detail {
    var asDomain: Variant.Processor.Model {
        .init(
            id: id,
            variantId: variantId,
            name: name,
            matchExtensions: matchExtensions,
            commandTemplate: commandTemplate,
            isActive: isActive,
            createdAt: createdAt,
            updatedAt: updatedAt
        )
    }
}

extension Variant.Processor.Table.List {
    var asDomain: Variant.Processor.Model {
        .init(
            id: id,
            variantId: variantId,
            name: name,
            matchExtensions: matchExtensions,
            commandTemplate: commandTemplate,
            isActive: isActive,
            createdAt: createdAt,
            updatedAt: updatedAt
        )
    }
}

extension Variant.Processor.Repository {
    public struct Database: Interface {
        public let context: DatabaseTransactionContext
        private let accessLayer: DatabaseAccessLayer<Variant.Processor.Table>

        public init(context: DatabaseTransactionContext) {
            self.context = context
            self.accessLayer = .init(context: context)
        }

        public func insert(_ model: Variant.Processor.Model.New) async throws
            -> Variant.Processor.Model
        {
            let row = Variant.Processor.Table.Insert(
                id: context.idGenerator.generate(),
                variantId: model.variantId,
                name: model.name,
                matchExtensions: model.matchExtensions,
                commandTemplate: model.commandTemplate,
                isActive: model.isActive
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

        public func update(_ model: Variant.Processor.Model) async throws
            -> Variant.Processor.Model
        {
            try await accessLayer.update(
                .init(
                    name: model.name,
                    matchExtensions: model.matchExtensions,
                    commandTemplate: model.commandTemplate,
                    isActive: model.isActive
                ),
                where: \.id,
                equals: model.id
            )
            guard
                let updated = try await accessLayer.selectFirst(
                    by: \.id,
                    equals: model.id
                )
            else {
                throw RepositoryError.notFound
            }
            return updated.asDomain
        }

        public func find(id: String) async throws -> Variant.Processor.Model? {
            try await accessLayer.selectFirst(by: \.id, equals: id)
                .map(\.asDomain)
        }

        public func list(variantId: String) async throws -> [Variant.Processor
            .Model]
        {
            try await accessLayer.select {
                $0.where(\.variantId, equals: variantId).order(by: \.name)
            }
            .map(\.asDomain)
        }

        public func listActive() async throws -> [Variant.Processor.Model] {
            let activeVariantIDs = Set(
                try await DatabaseAccessLayer<Variant.Table>(context: context)
                    .select { $0.where(\.isActive, equals: true) }
                    .map(\.id)
            )
            return
                try await accessLayer.select {
                    $0.where(\.isActive, equals: true).order(by: \.name)
                }
                .filter { activeVariantIDs.contains($0.variantId) }
                .map(\.asDomain)
        }

        public func delete(ids: [String]) async throws -> [String] {
            try await accessLayer.delete(where: \.id, in: ids)
            return ids
        }
    }
}
