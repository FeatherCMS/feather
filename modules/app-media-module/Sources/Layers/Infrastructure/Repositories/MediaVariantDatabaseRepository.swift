import FeatherDomain
import FeatherInfrastructure
import Foundation
import MediaDomain

extension MediaVariantTable.Row {
    var asDomain: MediaVariant {
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

public struct MediaVariantDatabaseRepository: MediaVariantRepository {
    public let context: DatabaseTransactionContext

    public init(context: DatabaseTransactionContext) { self.context = context }

    public func insert(_ model: MediaVariant.New) async throws -> MediaVariant {
        try await MediaVariantTable(connection: context.connection)
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

    public func update(_ model: MediaVariant) async throws -> MediaVariant {
        try await MediaVariantTable(connection: context.connection)
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

    public func find(id: String) async throws -> MediaVariant? {
        try await MediaVariantTable(connection: context.connection)
            .find(id: id)?
            .asDomain
    }
    public func list() async throws -> [MediaVariant] {
        try await MediaVariantTable(connection: context.connection).list()
            .map(\.asDomain)
    }
    public func listActive() async throws -> [MediaVariant] {
        try await MediaVariantTable(connection: context.connection).listActive()
            .map(\.asDomain)
    }
    public func delete(ids: [String]) async throws -> [String] {
        try await MediaVariantTable(connection: context.connection)
            .delete(ids: ids)
    }
}
