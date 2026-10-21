public import AuthDomain
public import AuthModule
import FeatherDBAL
import FeatherDatabase
import FeatherDomain
public import FeatherInfrastructure

import struct Foundation.Date

//
//  MagicLink.Repository.Database.swift
//  app-auth-module
//
//  Created by Binary Birds on 2026. 06. 18.

extension MagicLink.Table.Detail {
    var asDomain: MagicLink.Model {
        .init(
            id: id,
            authEmailId: authEmailId,
            token: token,
            expiresAt: expiresAt,
            isPersistent: isPersistent,
            isUsed: isUsed,
            createdAt: createdAt,
            updatedAt: updatedAt
        )
    }
}

extension MagicLink.Repository {
    public struct Database: Interface {

        private struct ConsumedRow {
            let id: String
            let authEmailId: String
            let token: String
            let expiresAt: Date
            let isPersistent: Bool
            let isUsed: Bool
            let createdAt: Date
            let updatedAt: Date

            init(from row: any DatabaseRow) throws {
                id = try row.decode(column: "id", as: String.self)
                authEmailId = try row.decode(
                    column: "auth_email_id",
                    as: String.self
                )
                token = try row.decode(column: "token", as: String.self)
                expiresAt = try row.decode(column: "expires_at", as: Date.self)
                isPersistent = try row.decode(
                    column: "is_persistent",
                    as: Bool.self
                )
                isUsed = try row.decode(column: "is_used", as: Bool.self)
                createdAt = try row.decode(column: "created_at", as: Date.self)
                updatedAt = try row.decode(column: "updated_at", as: Date.self)
            }

            var model: MagicLink.Model {
                .init(
                    id: id,
                    authEmailId: authEmailId,
                    token: token,
                    expiresAt: expiresAt,
                    isPersistent: isPersistent,
                    isUsed: isUsed,
                    createdAt: createdAt,
                    updatedAt: updatedAt
                )
            }
        }

        public let context: DatabaseTransactionContext
        public init(context: DatabaseTransactionContext) {
            self.context = context
        }

        public func findById(
            id: String
        ) async throws -> MagicLink.Model? {
            try await DatabaseAccessLayer<MagicLink.Table>(context: context)
                .selectFirst(by: \.id, equals: id)
                .map(\.asDomain)
        }

        public func insert(
            _ model: MagicLink.Model.New
        ) async throws -> MagicLink.Model {
            let accessLayer = DatabaseAccessLayer<MagicLink.Table>(
                context: context
            )
            let row = MagicLink.Table.Insert(
                id: context.idGenerator.generate(),
                authEmailId: model.authEmailId,
                token: model.token,
                expiresAt: Date(timeIntervalSinceNow: model.expiresAtInterval),
                isPersistent: model.isPersistent
            )
            try await accessLayer.insert(row)
            guard
                let saved = try await accessLayer.selectFirst(
                    by: \.id,
                    equals: row.id
                )
            else {
                throw RepositoryError.notFound
            }
            return saved.asDomain
        }

        public func update(
            _ model: MagicLink.Model
        ) async throws -> MagicLink.Model {
            let accessLayer = DatabaseAccessLayer<MagicLink.Table>(
                context: context
            )
            try await accessLayer.update(
                MagicLink.Table.Update(
                    authEmailId: model.authEmailId,
                    token: model.token,
                    expiresAt: model.expiresAt,
                    isPersistent: model.isPersistent,
                    isUsed: model.isUsed
                ),
                where: \.id,
                equals: model.id
            )
            guard
                let updated = try await accessLayer.selectFirst(
                    by: \.id,
                    equals: model.id
                )
            else {
                throw RepositoryError.notFound
            }
            return updated.asDomain
        }

        public func consumeByToken(
            token: String
        ) async throws -> MagicLink.Model {
            guard let consumed = try await consume(token: token)
            else {
                guard
                    let existing = try await DatabaseAccessLayer<
                        MagicLink.Table
                    >(
                        context: context
                    )
                    .selectFirst(by: \.token, equals: token)
                else {
                    throw MagicLink.Model.Error.invalidToken
                }
                if existing.isUsed {
                    throw MagicLink.Model.Error.alreadyUsed
                }
                if existing.expiresAt <= Date() {
                    throw MagicLink.Model.Error.expired
                }
                throw MagicLink.Model.Error.invalidToken
            }
            return consumed.model
        }

        private func consume(token: String) async throws -> ConsumedRow? {
            try await context.connection.run(
                query: #"""
                    UPDATE auth_magic_link
                    SET is_used=TRUE, updated_at=NOW()
                    WHERE token=\#(token)
                        AND is_used=FALSE
                        AND expires_at>NOW()
                    RETURNING *;
                    """#
            ) { rows in
                guard let row = try await rows.collect().first else {
                    return nil
                }
                return try ConsumedRow(from: row)
            }
        }

        public func delete(
            ids: [String]
        ) async throws -> [String] {
            try await DatabaseAccessLayer<MagicLink.Table>(context: context)
                .delete(where: \.id, in: ids)
            return ids
        }
    }
}
