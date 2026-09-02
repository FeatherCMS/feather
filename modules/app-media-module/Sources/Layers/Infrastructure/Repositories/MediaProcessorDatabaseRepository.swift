//
//  MediaProcessorDatabaseRepository.swift
//  app-media-module
//
//  Created by Binary Birds on 2026. 06. 18.

import FeatherDatabase
import FeatherDomain
import FeatherInfrastructure
import MediaDomain

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

public struct MediaProcessorDatabaseRepository: MediaProcessorRepository {
    public let context: DatabaseTransactionContext
    public init(context: DatabaseTransactionContext) {
        self.context = context
    }

    public func insert(
        _ model: MediaProcessor.New
    ) async throws -> MediaProcessor {
        try await MediaProcessorTable(connection: context.connection)
            .create(
                row: .init(
                    id: context.idGenerator.generate(),
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
        try await MediaProcessorTable(connection: context.connection)
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
        try await MediaProcessorTable(connection: context.connection)
            .find(id: id)?
            .asDomain
    }

    public func list() async throws -> [MediaProcessor] {
        try await MediaProcessorTable(connection: context.connection).list()
            .map(\.asDomain)
    }

    public func listActive() async throws -> [MediaProcessor] {
        try await MediaProcessorTable(connection: context.connection)
            .listActive()
            .map(\.asDomain)
    }

    public func delete(
        ids: [String]
    ) async throws -> [String] {
        return try await MediaProcessorTable(connection: context.connection).delete(ids: ids)
    }
}
