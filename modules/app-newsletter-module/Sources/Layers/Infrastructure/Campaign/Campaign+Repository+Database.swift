import FeatherDBAL
import FeatherDomain
public import FeatherInfrastructure
public import NewsletterDomain
public import NewsletterModule

extension Campaign.Table.Detail {
    var asDomain: Campaign.Model {
        .init(
            id: id,
            key: key,
            name: name,
            fromEmail: fromEmail,
            createdAt: createdAt,
            updatedAt: updatedAt
        )
    }
}

extension Campaign.Repository {
    public struct Database: Interface {
        public let context: DatabaseTransactionContext
        private let accessLayer: DatabaseAccessLayer<Campaign.Table>

        public init(context: DatabaseTransactionContext) {
            self.context = context
            self.accessLayer = .init(context: context)
        }

        public func insert(_ model: Campaign.Model.New) async throws
            -> Campaign.Model
        {
            let row = Campaign.Table.Insert(
                id: context.idGenerator.generate(),
                key: model.key,
                name: model.name,
                fromEmail: model.fromEmail
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

        public func findBy(id: String) async throws -> Campaign.Model? {
            try await accessLayer.selectFirst(by: \.id, equals: id)
                .map(\.asDomain)
        }

        public func findBy(key: String) async throws -> Campaign.Model? {
            try await accessLayer.selectFirst(by: \.key, equals: key)
                .map(\.asDomain)
        }

        public func update(_ model: Campaign.Model) async throws
            -> Campaign.Model
        {
            try await accessLayer.update(
                .init(
                    key: model.key,
                    name: model.name,
                    fromEmail: model.fromEmail
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
            try await accessLayer.delete(where: \.id, in: ids)
            return ids
        }
    }
}
