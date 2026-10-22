import FeatherDBAL
import FeatherDomain
public import FeatherInfrastructure
import Foundation
public import MediaDomain
public import MediaModule

extension Variant.Table.Row {
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

        public init(context: DatabaseTransactionContext) {
            self.context = context
        }

        public func insert(_ model: Variant.Model.New) async throws
            -> Variant.Model
        {
            try await Variant.Table(connection: context.connection)
                .create(
                    row: .init(
                        id: context.idGenerator.generate(),
                        key: model.key,
                        name: model.name,
                        isRequired: model.isRequired,
                        isActive: model.isActive,
                        createdAt: .init(),
                        updatedAt: .init()
                    )
                )
                .asDomain
        }

        public func update(_ model: Variant.Model) async throws -> Variant.Model
        {
            try await Variant.Table(connection: context.connection)
                .update(
                    row: .init(
                        id: model.id,
                        key: model.key,
                        name: model.name,
                        isRequired: model.isRequired,
                        isActive: model.isActive,
                        createdAt: model.createdAt,
                        updatedAt: model.updatedAt
                    )
                )
                .asDomain
        }

        public func find(id: String) async throws -> Variant.Model? {
            try await Variant.Table(connection: context.connection)
                .find(id: id)?
                .asDomain
        }
        public func list() async throws -> [Variant.Model] {
            try await Variant.Table(connection: context.connection).list()
                .map(\.asDomain)
        }
        public func listActive() async throws -> [Variant.Model] {
            try await Variant.Table(connection: context.connection)
                .listActive()
                .map(\.asDomain)
        }
        public func delete(ids: [String]) async throws -> [String] {
            try await DatabaseAccessLayer<Variant.Table>(context: context)
                .delete(where: \.id, in: ids)
            return ids
        }
    }
}
