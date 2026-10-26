import FeatherDBAL
import FeatherDomain
public import FeatherInfrastructure
public import MediaDomain
public import MediaModule

extension Variant.Table.Detail {
    var asDomain: Variant.Model {
        .init(
            id: id,
            key: key,
            name: name,
            isRequired: isRequired,
            isActive: isActive,
            createdAt: createdAt,
            updatedAt: updatedAt
        )
    }
}

extension Variant.Table.List {
    var asDomain: Variant.Model {
        .init(
            id: id,
            key: key,
            name: name,
            isRequired: isRequired,
            isActive: isActive,
            createdAt: createdAt,
            updatedAt: updatedAt
        )
    }
}

extension Variant.Repository {
    public struct Database: Interface {
        public let context: DatabaseTransactionContext
        private let accessLayer: DatabaseAccessLayer<Variant.Table>

        public init(context: DatabaseTransactionContext) {
            self.context = context
            self.accessLayer = .init(context: context)
        }

        public func insert(_ model: Variant.Model.New) async throws
            -> Variant.Model
        {
            let row = Variant.Table.Insert(
                id: context.idGenerator.generate(),
                key: model.key,
                name: model.name,
                isRequired: model.isRequired,
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

        public func update(_ model: Variant.Model) async throws -> Variant.Model
        {
            try await accessLayer.update(
                .init(
                    key: model.key,
                    name: model.name,
                    isRequired: model.isRequired,
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

        public func find(id: String) async throws -> Variant.Model? {
            try await accessLayer.selectFirst(by: \.id, equals: id)
                .map(\.asDomain)
        }

        public func list() async throws -> [Variant.Model] {
            try await accessLayer.select { $0.order(by: \.name) }
                .map(\.asDomain)
        }

        public func listActive() async throws -> [Variant.Model] {
            try await accessLayer.select {
                $0.where(\.isActive, equals: true).order(by: \.name)
            }
            .map(\.asDomain)
        }

        public func delete(ids: [String]) async throws -> [String] {
            try await accessLayer.delete(where: \.id, in: ids)
            return ids
        }
    }
}
