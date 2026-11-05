//
//  Menu+Repository+Database.swift
//  app-web-module
//
//  Created by Binary Birds on 2026. 06. 18.

import FeatherDBAL
import FeatherDomain
public import FeatherInfrastructure
public import WebDomain
public import WebModule

extension Menu.Table.Detail {
    var asDomain: Menu.Model {
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

extension Menu.Repository {
    public struct Database: Interface {

        public let context: DatabaseTransactionContext
        public init(context: DatabaseTransactionContext) {
            self.context = context
        }

        public func insert(
            _ model: Menu.Model.New
        ) async throws -> Menu.Model {
            let accessLayer = DatabaseAccessLayer<Menu.Table>(context: context)
            let id = context.idGenerator.generate()
            try await accessLayer.insert(
                Menu.Table.Insert(
                    id: id,
                    key: model.key,
                    name: model.name,
                    notes: model.notes
                )
            )
            guard
                let detail = try await accessLayer.selectFirst(
                    by: \.id,
                    equals: id
                )
            else {
                throw RepositoryError.notFound
            }
            return detail.asDomain
        }

        public func find(
            id: String
        ) async throws -> Menu.Model? {
            try await DatabaseAccessLayer<Menu.Table>(context: context)
                .selectFirst(by: \.id, equals: id)
                .map { $0.asDomain }
        }

        public func find(
            key: String
        ) async throws -> Menu.Model? {
            try await DatabaseAccessLayer<Menu.Table>(context: context)
                .selectFirst(by: \.key, equals: key)
                .map { $0.asDomain }
        }

        public func update(
            _ model: Menu.Model
        ) async throws -> Menu.Model {
            let accessLayer = DatabaseAccessLayer<Menu.Table>(context: context)
            try await accessLayer.update(
                Menu.Table.Update(
                    key: model.key,
                    name: model.name,
                    notes: model.notes
                ),
                where: \.id,
                equals: model.id
            )
            guard
                let detail = try await accessLayer.selectFirst(
                    by: \.id,
                    equals: model.id
                )
            else {
                throw RepositoryError.notFound
            }
            return detail.asDomain
        }

        public func delete(
            ids: [String]
        ) async throws -> [String] {
            try await DatabaseAccessLayer<Menu.Table>(context: context)
                .delete(where: \.id, in: ids)
            return ids
        }
    }
}
