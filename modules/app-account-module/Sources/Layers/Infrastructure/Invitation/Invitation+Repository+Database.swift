public import AccountDomain
public import AccountModule
import FeatherDBAL
import FeatherDomain
public import FeatherInfrastructure
import Foundation

extension Invitation.Table.Detail {
    fileprivate func asDomain() throws -> Invitation.Model {
        let roleIds = try JSONDecoder()
            .decode([String].self, from: Data(roleIds.utf8))
        return .init(
            id: id,
            userId: userId,
            email: email,
            token: token,
            roleIDs: roleIds,
            expiresAt: expiresAt,
            createdAt: createdAt,
            updatedAt: updatedAt
        )
    }
}

extension Invitation.Repository {
    public struct Database: Interface {
        public let context: DatabaseTransactionContext

        public init(context: DatabaseTransactionContext) {
            self.context = context
        }

        public func findBy(id: String) async throws -> Invitation.Model? {
            try await DatabaseAccessLayer<Invitation.Table>(context: context)
                .selectFirst(
                    by: \.id,
                    equals: id,
                    as: Invitation.Table.Detail.self
                )?
                .asDomain()
        }

        public func findBy(token: String) async throws -> Invitation.Model? {
            try await DatabaseAccessLayer<Invitation.Table>(context: context)
                .selectFirst(
                    by: \.token,
                    equals: token,
                    as: Invitation.Table.Detail.self
                )?
                .asDomain()
        }

        public func insert(_ model: Invitation.Model.New) async throws
            -> Invitation.Model
        {
            let id = context.idGenerator.generate()
            let roleIds = String(
                decoding: try JSONEncoder().encode(model.roleIDs),
                as: UTF8.self
            )
            let accessLayer = DatabaseAccessLayer<Invitation.Table>(
                context: context
            )
            try await accessLayer.insert(
                .init(
                    id: id,
                    userId: model.userId,
                    email: model.email,
                    token: model.token,
                    roleIds: roleIds,
                    expiresAt: Date()
                        .addingTimeInterval(model.expiresAtInterval)
                )
            )
            guard
                let detail = try await accessLayer.selectFirst(
                    by: \.id,
                    equals: id,
                    as: Invitation.Table.Detail.self
                )
            else {
                throw RepositoryError.notFound
            }
            return try detail.asDomain()
        }

        public func update(_ model: Invitation.Model) async throws
            -> Invitation.Model
        {
            let roleIds = String(
                decoding: try JSONEncoder().encode(model.roleIDs),
                as: UTF8.self
            )
            let accessLayer = DatabaseAccessLayer<Invitation.Table>(
                context: context
            )
            try await accessLayer.update(
                .init(
                    userId: model.userId,
                    email: model.email,
                    token: model.token,
                    roleIds: roleIds,
                    expiresAt: model.expiresAt
                ),
                where: \.id,
                equals: model.id
            )
            guard
                let detail = try await accessLayer.selectFirst(
                    by: \.id,
                    equals: model.id,
                    as: Invitation.Table.Detail.self
                )
            else {
                throw RepositoryError.notFound
            }
            return try detail.asDomain()
        }

        public func delete(ids: [String]) async throws -> [String] {
            try await DatabaseAccessLayer<Invitation.Table>(context: context)
                .delete(where: \.id, in: ids)
            return ids
        }
    }
}
