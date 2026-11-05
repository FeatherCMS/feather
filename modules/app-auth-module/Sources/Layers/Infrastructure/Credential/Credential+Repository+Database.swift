public import AuthDomain
public import AuthModule
import FeatherDBAL
import FeatherDomain
public import FeatherInfrastructure

extension Credential.Table.Detail {
    var asDomain: Credential.Model {
        .init(
            id: id,
            authEmailId: authEmailId,
            passwordHash: passwordHash,
            createdAt: createdAt,
            updatedAt: updatedAt
        )
    }
}

extension Credential.Repository {
    public struct Database: Interface {
        public let context: DatabaseTransactionContext
        private let accessLayer: DatabaseAccessLayer<Credential.Table>

        public init(context: DatabaseTransactionContext) {
            self.context = context
            self.accessLayer = .init(context: context)
        }

        public func findBy(id: String) async throws -> Credential.Model? {
            try await accessLayer.selectFirst(by: \.id, equals: id)?.asDomain
        }

        public func findBy(userId: String) async throws -> Credential.Model? {
            guard
                let authEmail = try await Email.Repository
                    .Database(context: context)
                    .findBy(identityId: userId)
            else {
                return nil
            }
            return try await accessLayer
                .selectFirst(by: \.authEmailId, equals: authEmail.id)?
                .asDomain
        }

        public func findBy(email: String) async throws -> Credential.Model? {
            guard
                let authEmail = try await Email.Repository
                    .Database(context: context)
                    .findBy(email: email)
            else {
                return nil
            }
            return try await accessLayer
                .selectFirst(by: \.authEmailId, equals: authEmail.id)?
                .asDomain
        }

        public func insert(_ model: Credential.Model.New) async throws
            -> Credential.Model
        {
            let id = context.idGenerator.generate()
            try await accessLayer.insert(
                Credential.Table.Insert(
                    id: id,
                    authEmailId: model.authEmailId,
                    passwordHash: model.passwordHash
                )
            )
            guard
                let result = try await accessLayer.selectFirst(
                    by: \.id,
                    equals: id
                )
            else {
                throw RepositoryError.notFound
            }
            return result.asDomain
        }

        public func update(_ model: Credential.Model) async throws
            -> Credential.Model
        {
            try await accessLayer.update(
                Credential.Table.Update(
                    authEmailId: model.authEmailId,
                    passwordHash: model.passwordHash
                ),
                where: \.id,
                equals: model.id
            )
            guard
                let result = try await accessLayer.selectFirst(
                    by: \.id,
                    equals: model.id
                )
            else {
                throw RepositoryError.notFound
            }
            return result.asDomain
        }

        public func delete(ids: [String]) async throws -> [String] {
            try await accessLayer.delete(where: \.id, in: ids)
            return ids
        }
    }
}
