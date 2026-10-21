public import AuthDomain
public import AuthModule
import FeatherDBAL
import FeatherDomain
public import FeatherInfrastructure

extension AuthEmail.Table.Detail {
    var asDomain: AuthEmail.Model {
        .init(
            id: id,
            identityId: identityId,
            email: email,
            createdAt: createdAt,
            updatedAt: updatedAt
        )
    }
}

extension AuthEmail.Repository {
    public struct Database: Interface {
        public let context: DatabaseTransactionContext

        public init(context: DatabaseTransactionContext) {
            self.context = context
        }

        public func list() async throws -> [AuthEmail.Model] {
            try await DatabaseAccessLayer<AuthEmail.Table>(context: context)
                .select(as: AuthEmail.Table.Detail.self) { $0 }
                .map(\.asDomain)
        }

        public func findBy(id: String) async throws -> AuthEmail.Model? {
            try await DatabaseAccessLayer<AuthEmail.Table>(context: context)
                .selectFirst(by: \.id, equals: id)?
                .asDomain
        }

        public func findBy(email: String) async throws -> AuthEmail
            .Model?
        {
            try await DatabaseAccessLayer<AuthEmail.Table>(context: context)
                .selectFirst(by: \.email, equals: email)?
                .asDomain
        }

        public func findBy(identityId: String) async throws -> AuthEmail
            .Model?
        {
            try await DatabaseAccessLayer<AuthEmail.Table>(context: context)
                .selectFirst(by: \.identityId, equals: identityId)?
                .asDomain
        }

        public func insert(identityId: String, email: String) async throws
            -> AuthEmail.Model
        {
            let accessLayer = DatabaseAccessLayer<AuthEmail.Table>(
                context: context
            )
            let row = AuthEmail.Table.Insert(
                id: context.idGenerator.generate(),
                identityId: identityId,
                email: email
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

        public func update(_ model: AuthEmail.Model) async throws
            -> AuthEmail.Model
        {
            let accessLayer = DatabaseAccessLayer<AuthEmail.Table>(
                context: context
            )
            try await accessLayer.update(
                .init(identityId: model.identityId, email: model.email),
                where: \.id,
                equals: model.id
            )
            guard
                let row = try await accessLayer.selectFirst(
                    by: \.id,
                    equals: model.id
                )
            else {
                throw RepositoryError.notFound
            }
            return row.asDomain
        }

        public func delete(ids: [String]) async throws -> [String] {
            try await DatabaseAccessLayer<AuthEmail.Table>(context: context)
                .delete(where: \.id, in: ids)
            return ids
        }
    }
}
