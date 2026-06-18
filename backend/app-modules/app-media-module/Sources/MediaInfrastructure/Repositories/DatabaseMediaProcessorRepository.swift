import MediaDomain
import FeatherDatabase
import struct Foundation.Date

extension MediaProcessorTable.Row {
    var asDomain: MediaProcessor {
        .init(
            id: id,
            name: name,
            matchExtensions: matchExtensions,
            commandTemplate: commandTemplate,
            isRequired: isRequired,
            isActive: isActive,
            createdAt: createdAt,
            updatedAt: updatedAt
        )
    }
}

public struct DatabaseMediaProcessorRepository: MediaProcessorRepository {
    public let connection: any DatabaseConnection

    public init(connection: any DatabaseConnection) {
        self.connection = connection
    }

    public func insert(
        _ model: MediaProcessor.New
    ) async throws -> MediaProcessor {
        try await MediaProcessorTable(connection: connection)
            .create(
                row: .init(
                    id: model.id,
                    name: model.name,
                    matchExtensions: model.matchExtensions,
                    commandTemplate: model.commandTemplate,
                    isRequired: model.isRequired,
                    isActive: model.isActive,
                    createdAt: .init(),
                    updatedAt: .init()
                )
            )
            .asDomain
    }

    public func update(
        _ model: MediaProcessor
    ) async throws -> MediaProcessor {
        try await MediaProcessorTable(connection: connection)
            .update(
                row: .init(
                    id: model.id,
                    name: model.name,
                    matchExtensions: model.matchExtensions,
                    commandTemplate: model.commandTemplate,
                    isRequired: model.isRequired,
                    isActive: model.isActive,
                    createdAt: model.createdAt,
                    updatedAt: model.updatedAt
                )
            )
            .asDomain
    }

    public func find(
        id: String
    ) async throws -> MediaProcessor? {
        try await MediaProcessorTable(connection: connection).find(id: id)?
            .asDomain
    }

    public func list() async throws -> [MediaProcessor] {
        try await MediaProcessorTable(connection: connection).list()
            .map(\.asDomain)
    }

    public func listActive() async throws -> [MediaProcessor] {
        try await MediaProcessorTable(connection: connection).listActive()
            .map(\.asDomain)
    }

    public func delete(
        id: String
    ) async throws -> Bool {
        try await MediaProcessorTable(connection: connection).delete(id: id)
    }
}
