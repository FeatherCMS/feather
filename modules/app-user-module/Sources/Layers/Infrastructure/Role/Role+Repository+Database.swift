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

extension Role.Table.Detail {
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
    public struct Database: Interface {

        public let context: DatabaseTransactionContext
        public let idGenerator: any IDGenerator

        public init(context: DatabaseTransactionContext) {
            self.context = context
            self.idGenerator = context.idGenerator
        }

        public func findBy(
            id: String
        ) async throws -> Role.Model? {
            try await DatabaseAccessLayer<Role.Table>(context: context)
                .selectFirst(by: \.id, equals: id, as: Role.Table.Detail.self)?
                .asDomain
        }

        public func findBy(
            name: String
        ) async throws -> Role.Model? {
            try await DatabaseAccessLayer<Role.Table>(context: context)
                .selectFirst(
                    as: Role.Table.Detail.self
                ) { $0.where(\.name, equals: name) }?
                .asDomain
        }

        public func findBy(
            key: String
        ) async throws -> Role.Model? {
            try await DatabaseAccessLayer<Role.Table>(context: context)
                .selectFirst(by: \.key, equals: key, as: Role.Table.Detail.self)?
                .asDomain
        }

        public func insert(
            _ model: Role.Model.New
        ) async throws -> Role.Model {
            let accessLayer = DatabaseAccessLayer<Role.Table>(context: context)
            let id = idGenerator.generate()
            try await accessLayer.insert(
                .init(
                    id: id,
                    key: model.key,
                    name: model.name,
                    notes: model.notes
                )
            )
            guard
                let saved = try await accessLayer.selectFirst(
                    by: \.id,
                    equals: id,
                    as: Role.Table.Detail.self
                )
            else {
                throw RepositoryError.notFound
            }
            return saved.asDomain
        }

        public func update(
            _ model: Role.Model
        ) async throws -> Role.Model {
            let accessLayer = DatabaseAccessLayer<Role.Table>(context: context)
            try await accessLayer.update(
                .init(
                    key: model.key,
                    name: model.name,
                    notes: model.notes
                ),
                where: \.id,
                equals: model.id
            )
            guard
                let updated = try await accessLayer.selectFirst(
                    by: \.id,
                    equals: model.id,
                    as: Role.Table.Detail.self
                )
            else {
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
