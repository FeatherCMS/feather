import FeatherDBAL
import FeatherDomain
public import FeatherInfrastructure
import Foundation
public import MediaDomain
public import MediaModule

extension Variant.Processor.Table.Row {
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

        public init(context: DatabaseTransactionContext) {
            self.context = context
        }

        public func insert(_ model: Variant.Processor.Model.New) async throws
            -> Variant.Processor.Model
        {
            try await Variant.Processor.Table(connection: context.connection)
                .create(
                    row: .init(
                        id: context.idGenerator.generate(),
                        variantId: model.variantId,
                        name: model.name,
                        matchExtensions: model.matchExtensions,
                        commandTemplate: model.commandTemplate,
                        isActive: model.isActive,
                        createdAt: .init(),
                        updatedAt: .init()
                    )
                )
                .asDomain
        }

        public func update(_ model: Variant.Processor.Model) async throws
            -> Variant.Processor.Model
        {
            try await Variant.Processor.Table(connection: context.connection)
                .update(
                    row: .init(
                        id: model.id,
                        variantId: model.variantId,
                        name: model.name,
                        matchExtensions: model.matchExtensions,
                        commandTemplate: model.commandTemplate,
                        isActive: model.isActive,
                        createdAt: model.createdAt,
                        updatedAt: model.updatedAt
                    )
                )
                .asDomain
        }

        public func find(id: String) async throws -> Variant.Processor.Model? {
            try await Variant.Processor.Table(connection: context.connection)
                .find(id: id)?
                .asDomain
        }
        public func list(variantId: String) async throws -> [Variant.Processor
            .Model]
        {
            try await Variant.Processor.Table(connection: context.connection)
                .list(variantId: variantId).map(\.asDomain)
        }
        public func listActive() async throws -> [Variant.Processor.Model] {
            try await Variant.Processor.Table(connection: context.connection)
                .listActive().map(\.asDomain)
        }
        public func delete(ids: [String]) async throws -> [String] {
            try await DatabaseAccessLayer<Variant.Processor.Table>(
                context: context
            )
            .delete(where: \.id, in: ids)
            return ids
        }
    }
}
