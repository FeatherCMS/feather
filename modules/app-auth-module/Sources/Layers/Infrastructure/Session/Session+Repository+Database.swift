public import AuthDomain
public import AuthModule
import FeatherDBAL
import FeatherDomain
public import FeatherInfrastructure
import Foundation

extension Session.Table.Detail {
    var asDomain: Session.Model {
        .init(
            id: id,
            token: token,
            identityId: identityId,
            authenticationType: authenticationType,
            authenticationReference: authenticationReference,
            expiresAt: expiresAt.timeIntervalSince1970,
            isPersistent: isPersistent,
            createdAt: createdAt,
            updatedAt: updatedAt
        )
    }
}

extension Session.Repository {
    public struct Database: Interface {
        public let context: DatabaseTransactionContext

        public init(context: DatabaseTransactionContext) {
            self.context = context
        }

        public func findBy(id: String) async throws -> Session.Model? {
            try await DatabaseAccessLayer<Session.Table>(context: context)
                .selectFirst(by: \.id, equals: id)
                .map(\.asDomain)
        }

        public func findBy(token: String) async throws -> Session.Model? {
            try await DatabaseAccessLayer<Session.Table>(context: context)
                .selectFirst(by: \.token, equals: token)
                .map(\.asDomain)
        }

        public func insert(_ model: Session.Model.New) async throws
            -> Session.Model
        {
            let accessLayer = DatabaseAccessLayer<Session.Table>(
                context: context
            )
            let row = Session.Table.Insert(
                id: context.idGenerator.generate(),
                token: model.token,
                identityId: model.identityId,
                authenticationType: model.authenticationType,
                authenticationReference: model.authenticationReference,
                isPersistent: model.isPersistent,
                expiresAt: Date(timeIntervalSinceNow: model.expiresAtInterval)
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

        public func update(_ model: Session.Model) async throws -> Session.Model
        {
            let accessLayer = DatabaseAccessLayer<Session.Table>(
                context: context
            )
            try await accessLayer.update(
                .init(
                    token: model.token,
                    identityId: model.identityId,
                    authenticationType: model.authenticationType,
                    authenticationReference: model.authenticationReference,
                    isPersistent: model.isPersistent,
                    expiresAt: Date(timeIntervalSince1970: model.expiresAt)
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

        public func delete(ids: [String]) async throws -> [String] {
            try await DatabaseAccessLayer<Session.Table>(context: context)
                .delete(where: \.id, in: ids)
            return ids
        }
    }
}
