public import SystemModule
//
//  Variable+Repository+Database.swift
//  app-system-module
//
//  Created by Tibor Bödecs on 2026. 06. 18.
//

import FeatherDBAL
import FeatherDomain
public import FeatherInfrastructure
public import SystemDomain

extension SystemModule.Variable.Repository {
    public struct Database: SystemModule.Variable.Repository.Interface {

        public let context: any DatabaseContext
        private let accessLayer: DatabaseAccessLayer<Variable.Table>

        public init(context: any DatabaseContext) {
            self.context = context
            self.accessLayer = .init(context: context)
        }

        public func insert(_ model: SystemModule.Variable.Model.New)
            async throws
            -> SystemModule.Variable.Model
        {
            let row = Variable.Table.Insert(
                id: context.idGenerator.generate(),
                key: model.key,
                value: model.value,
                name: model.name,
                notes: model.notes
            )
            try await accessLayer.insert(row)
            return .init(
                id: row.id,
                key: row.key,
                value: row.value,
                name: row.name,
                notes: row.notes
            )
        }

        public func update(_ model: SystemModule.Variable.Model) async throws
            -> SystemModule.Variable.Model
        {
            let row = Variable.Table.Update(
                key: model.key,
                value: model.value,
                name: model.name,
                notes: model.notes
            )
            try await accessLayer.update(row, where: \.id, equals: model.id)
            return model
        }

        public func find(id: String) async throws -> SystemModule.Variable
            .Model?
        {
            try await accessLayer.selectFirst(by: \.id, equals: id)
                .map(mapDetail)
        }

        public func find(key: String) async throws -> SystemModule.Variable
            .Model?
        {
            try await accessLayer.selectFirst(by: \.key, equals: key)
                .map(mapDetail)
        }

        public func delete(ids: [String]) async throws {
            _ = try await accessLayer.delete(where: \.id, in: ids)
        }

        private func mapDetail(
            _ row: Variable.Table.Detail
        ) -> SystemModule.Variable.Model {
            .init(
                id: row.id,
                key: row.key,
                value: row.value,
                name: row.name,
                notes: row.notes
            )
        }
    }
}
