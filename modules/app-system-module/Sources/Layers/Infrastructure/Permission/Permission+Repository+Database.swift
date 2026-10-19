public import SystemModule
//
//  Permission+Repository+Database.swift
//  app-system-module
//
//  Created by Tibor Bödecs on 2026. 06. 18.
//

import FeatherDBAL
import FeatherDomain
public import FeatherInfrastructure
public import SystemDomain

extension SystemModule.Permission.Repository {
    public struct Database: SystemModule.Permission.Repository.Interface {

        public let context: any DatabaseContext
        private let accessLayer: DatabaseAccessLayer<Permission.Table>

        public init(context: any DatabaseContext) {
            self.context = context
            self.accessLayer = .init(context: context)
        }

        public func insert(_ model: SystemModule.Permission.Model.New)
            async throws -> SystemModule.Permission.Model
        {
            let row = Permission.Table.Insert(
                id: context.idGenerator.generate(),
                key: model.key,
                name: model.name,
                notes: model.notes
            )
            try await accessLayer.insert(row)
            return .init(
                id: row.id,
                key: row.key,
                name: row.name,
                notes: row.notes
            )
        }

        public func update(_ model: SystemModule.Permission.Model) async throws
            -> SystemModule.Permission.Model
        {
            let row = Permission.Table.Update(
                key: model.key,
                name: model.name,
                notes: model.notes
            )
            try await accessLayer.update(row, where: \.id, equals: model.id)
            return model
        }

        public func find(id: String) async throws -> SystemModule.Permission
            .Model?
        {
            try await accessLayer.selectFirst(by: \.id, equals: id)
                .map(mapDetail)
        }

        public func find(key: String) async throws -> SystemModule.Permission
            .Model?
        {
            try await accessLayer.selectFirst(by: \.key, equals: key)
                .map(mapDetail)
        }

        public func delete(ids: [String]) async throws {
            _ = try await accessLayer.delete(where: \.id, in: ids)
        }

        private func mapDetail(_ row: Permission.Table.Detail)
            -> SystemModule.Permission.Model
        {
            .init(
                id: row.id,
                key: row.key,
                name: row.name,
                notes: row.notes
            )
        }
    }
}
