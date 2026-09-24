import FeatherDomain
public import FeatherInfrastructure
import Foundation
public import MediaDomain

extension MediaVariantProcessorTable.Row {
    var asDomain: MediaVariantProcessor {
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

public struct MediaVariantProcessorDatabaseRepository:
    MediaVariantProcessorRepository
{
    public let context: DatabaseTransactionContext

    public init(context: DatabaseTransactionContext) { self.context = context }

    public func insert(_ model: MediaVariantProcessor.New) async throws
        -> MediaVariantProcessor
    {
        try await MediaVariantProcessorTable(connection: context.connection)
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

    public func update(_ model: MediaVariantProcessor) async throws
        -> MediaVariantProcessor
    {
        try await MediaVariantProcessorTable(connection: context.connection)
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

    public func find(id: String) async throws -> MediaVariantProcessor? {
        try await MediaVariantProcessorTable(connection: context.connection)
            .find(id: id)?
            .asDomain
    }
    public func list(variantId: String) async throws -> [MediaVariantProcessor]
    {
        try await MediaVariantProcessorTable(connection: context.connection)
            .list(variantId: variantId).map(\.asDomain)
    }
    public func listActive() async throws -> [MediaVariantProcessor] {
        try await MediaVariantProcessorTable(connection: context.connection)
            .listActive().map(\.asDomain)
    }
    public func delete(ids: [String]) async throws -> [String] {
        try await MediaVariantProcessorTable(connection: context.connection)
            .delete(ids: ids)
    }
}
