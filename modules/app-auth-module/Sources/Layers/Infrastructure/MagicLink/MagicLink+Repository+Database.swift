public import AuthDomain
public import AuthModule
import FeatherDBAL
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
            guard
                let consumed = try await MagicLinkConsumeQuery(
                    connection: context.connection
                ).consume(token: token)
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
            return consumed
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
