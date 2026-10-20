//
//  Role.Repository.Database.swift
//  app-user-module
//
//  Created by Binary Birds on 2026. 06. 18.

import FeatherDBAL
public import FeatherDomain
public import FeatherInfrastructure
public import UserDomain
public import UserModule

import struct Foundation.Date

extension Role.Table.Row {
    var asDomain: Role.Model {
        .init(
            id: id,
            key: key,
            name: name,
            notes: notes,
            createdAt: createdAt,
            updatedAt: updatedAt
        )
    }
}

extension Role.Repository {
    public struct Database: Role.Repository.Interface {

        public let context: DatabaseTransactionContext
        public let idGenerator: any IDGenerator

        public init(context: DatabaseTransactionContext) {
            self.context = context
            self.idGenerator = context.idGenerator
        }

        public func findBy(
            id: String
        ) async throws -> Role.Model? {
            let table = Role.Table(connection: context.connection)
            return try await table.find(id: id)?.asDomain
        }

        public func findBy(
            name: String
        ) async throws -> Role.Model? {
            let table = Role.Table(connection: context.connection)
            return try await table.find(name: name)?.asDomain
        }

        public func findBy(
            key: String
        ) async throws -> Role.Model? {
            let table = Role.Table(connection: context.connection)
            return try await table.find(key: key)?.asDomain
        }

        public func insert(
            _ model: Role.Model.New
        ) async throws -> Role.Model {
            let table = Role.Table(connection: context.connection)
            let saved = try await table.save(
                row: .init(
                    id: idGenerator.generate(),
                    key: model.key,
                    name: model.name,
                    notes: model.notes,
                    createdAt: .init(timeIntervalSince1970: 0),
                    updatedAt: .init(timeIntervalSince1970: 0)
                )
            )
            return saved.asDomain
        }

        public func update(
            _ model: Role.Model
        ) async throws -> Role.Model {
            let table = Role.Table(connection: context.connection)
            let updated = try await table.update(
                id: model.id,
                row: .init(
                    id: model.id,
                    key: model.key,
                    name: model.name,
                    notes: model.notes,
                    createdAt: model.createdAt,
                    updatedAt: model.updatedAt
                )
            )
            guard let updated else {
                throw RepositoryError.notFound
            }
            return updated.asDomain
        }

        public func delete(
            ids: [String]
        ) async throws -> [String] {
            try await DatabaseAccessLayer<Role.Table>(context: context)
                .delete(where: \.id, in: ids)
            return ids
        }
    }
}
