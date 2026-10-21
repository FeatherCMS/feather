//
//  Identity.Repository.Database.swift
//  app-user-module
//
//  Created by Binary Birds on 2026. 06. 18.

import FeatherApplication
import FeatherDBAL
import FeatherDomain
public import FeatherInfrastructure
import UserApplication
public import UserDomain
public import UserModule

extension Identity.Table.Detail {
    var asDomain: Identity.Model {
        get throws {
            guard let status = Identity.Model.Status(rawValue: status) else {
                throw RepositoryError.invalidEnumValue(status)
            }
            return .init(
                id: id,
                name: name,
                status: status,
                isRoot: isRoot,
                createdAt: createdAt,
                updatedAt: updatedAt
            )
        }
    }
}

extension Identity.Repository {
    public struct Database: Identity.Repository.Interface {

        public let context: DatabaseTransactionContext
        public init(context: DatabaseTransactionContext) {
            self.context = context
        }

        public func insert(
            _ model: Identity.Model.New
        ) async throws -> Identity.Model {
            try await insert(id: context.idGenerator.generate(), model: model)
        }

        public func insert(
            id: String,
            model: Identity.Model.New
        ) async throws -> Identity.Model {
            let accessLayer = DatabaseAccessLayer<Identity.Table>(
                context: context
            )
            try await accessLayer.insert(
                .init(
                    id: id,
                    name: model.name,
                    status: model.status.rawValue,
                    isRoot: model.isRoot
                )
            )
            guard
                let saved = try await accessLayer.selectFirst(
                    by: \.id,
                    equals: id,
                    as: Identity.Table.Detail.self
                )
            else {
                throw RepositoryError.notFound
            }
            return try saved.asDomain
        }

        public func findBy(
            id: String
        ) async throws -> Identity.Model? {
            let accessLayer = DatabaseAccessLayer<Identity.Table>(
                context: context
            )
            return try await accessLayer.selectFirst(
                by: \.id,
                equals: id,
                as: Identity.Table.Detail.self
            )?
            .asDomain
        }

        public func findRoot() async throws -> Identity.Model? {
            let accessLayer = DatabaseAccessLayer<Identity.Table>(
                context: context
            )
            return try await accessLayer.selectFirst(
                as: Identity.Table.Detail.self
            ) {
                $0.where(\.isRoot, equals: true)
                    .order(by: [.init(by: \.createdAt)]).limit(1)
            }?
            .asDomain
        }

        public func findRoleIdsBy(
            identityId: String
        ) async throws -> [String] {
            let rows = try await DatabaseAccessLayer<IdentityRole.Table>(
                context: context
            )
            .select(as: IdentityRole.Table.RoleID.self) {
                $0.where(\.identityId, equals: identityId)
                    .order(by: [.init(by: \.roleId)])
            }
            return rows.map(\.roleId)
        }

        public func update(
            _ model: Identity.Model
        ) async throws -> Identity.Model {
            let accessLayer = DatabaseAccessLayer<Identity.Table>(
                context: context
            )
            try await accessLayer.update(
                .init(
                    id: model.id,
                    name: model.name,
                    status: model.status.rawValue,
                    isRoot: model.isRoot
                ),
                where: \.id,
                equals: model.id
            )
            guard
                let updated = try await accessLayer.selectFirst(
                    by: \.id,
                    equals: model.id,
                    as: Identity.Table.Detail.self
                )
            else {
                throw RepositoryError.notFound
            }
            return try updated.asDomain
        }

        public func replaceRoleIds(
            identityId: String,
            roleIds: [String]
        ) async throws {
            let accessLayer = DatabaseAccessLayer<IdentityRole.Table>(
                context: context
            )
            try await accessLayer.delete(
                where: \.identityId,
                equals: identityId
            )
            try await accessLayer.insert(
                Array(Set(roleIds))
                    .map {
                        IdentityRole.Table.Insert(
                            roleId: $0,
                            identityId: identityId
                        )
                    }
            )
        }

        public func delete(
            ids: [String]
        ) async throws -> [String] {
            try await DatabaseAccessLayer<Identity.Table>(context: context)
                .delete(where: \.id, in: ids)
            return ids
        }
    }
}
