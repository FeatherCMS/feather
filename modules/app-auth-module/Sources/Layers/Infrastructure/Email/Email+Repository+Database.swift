public import AuthDomain
public import AuthModule
import FeatherDBAL
import FeatherDomain
public import FeatherInfrastructure

extension Email.Table.Detail {
    var asDomain: Email.Model {
        .init(
            id: id,
            identityId: identityId,
            email: email,
            createdAt: createdAt,
            updatedAt: updatedAt
        )
    }
}

extension Email.Repository {
    public struct Database: Interface {
        public let context: DatabaseTransactionContext

        public init(context: DatabaseTransactionContext) {
            self.context = context
        }

        public func list() async throws -> [Email.Model] {
            try await DatabaseAccessLayer<Email.Table>(context: context)
                .select(as: Email.Table.Detail.self) { $0 }
                .map(\.asDomain)
        }

        public func findBy(id: String) async throws -> Email.Model? {
            try await DatabaseAccessLayer<Email.Table>(context: context)
                .selectFirst(by: \.id, equals: id)?
                .asDomain
        }

        public func findBy(email: String) async throws -> Email.Model? {
            try await DatabaseAccessLayer<Email.Table>(context: context)
                .selectFirst(by: \.email, equals: email)?
                .asDomain
        }

        public func findBy(identityId: String) async throws -> Email.Model? {
            try await DatabaseAccessLayer<Email.Table>(context: context)
                .selectFirst(by: \.identityId, equals: identityId)?
                .asDomain
        }

        public func insert(identityId: String, email: String) async throws
            -> Email.Model
        {
            let accessLayer = DatabaseAccessLayer<Email.Table>(
                context: context
            )
            let row = Email.Table.Insert(
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

        public func update(_ model: Email.Model) async throws
            -> Email.Model
        {
            let accessLayer = DatabaseAccessLayer<Email.Table>(
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
            try await DatabaseAccessLayer<Email.Table>(context: context)
                .delete(where: \.id, in: ids)
            return ids
        }
    }
}
