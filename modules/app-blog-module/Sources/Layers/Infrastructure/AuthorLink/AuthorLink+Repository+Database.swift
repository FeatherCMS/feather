public import BlogDomain
public import BlogModule
import FeatherDBAL
import FeatherDomain
public import FeatherInfrastructure

extension AuthorLink.Table.Detail {
    var asDomain: AuthorLink.Model {
        .init(
            id: id,
            authorId: authorId,
            label: label,
            url: url,
            priority: priority,
            isBlank: isBlank,
            permission: permission,
            notes: notes,
            createdAt: createdAt,
            updatedAt: updatedAt
        )
    }
}

extension AuthorLink.Repository {
    public struct Database: Interface {
        public let context: DatabaseTransactionContext

        public init(context: DatabaseTransactionContext) {
            self.context = context
        }

        public func insert(_ model: AuthorLink.Model.New) async throws
            -> AuthorLink.Model
        {
            let accessLayer = DatabaseAccessLayer<AuthorLink.Table>(
                context: context
            )
            let id = context.idGenerator.generate()
            try await accessLayer.insert(
                AuthorLink.Table.Insert(
                    id: id,
                    authorId: model.authorId,
                    label: model.label,
                    url: model.url,
                    priority: model.priority,
                    isBlank: model.isBlank,
                    permission: model.permission,
                    notes: model.notes
                )
            )
            guard
                let detail = try await accessLayer.selectFirst(
                    by: \.id,
                    equals: id
                )
            else {
                throw RepositoryError.notFound
            }
            return detail.asDomain
        }

        public func find(id: String) async throws -> AuthorLink.Model? {
            try await DatabaseAccessLayer<AuthorLink.Table>(context: context)
                .selectFirst(by: \.id, equals: id)
                .map(\.asDomain)
        }

        public func update(_ model: AuthorLink.Model) async throws
            -> AuthorLink.Model
        {
            let accessLayer = DatabaseAccessLayer<AuthorLink.Table>(
                context: context
            )
            try await accessLayer.update(
                AuthorLink.Table.Update(
                    authorId: model.authorId,
                    label: model.label,
                    url: model.url,
                    priority: model.priority,
                    isBlank: model.isBlank,
                    permission: model.permission,
                    notes: model.notes
                ),
                where: \.id,
                equals: model.id
            )
            guard
                let detail = try await accessLayer.selectFirst(
                    by: \.id,
                    equals: model.id
                )
            else {
                throw RepositoryError.notFound
            }
            return detail.asDomain
        }

        public func delete(ids: [String]) async throws -> [String] {
            try await DatabaseAccessLayer<AuthorLink.Table>(context: context)
                .delete(where: \.id, in: ids)
            return ids
        }
    }
}
