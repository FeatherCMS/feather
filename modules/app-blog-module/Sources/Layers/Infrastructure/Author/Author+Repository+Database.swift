public import BlogDomain
public import BlogModule
import FeatherDBAL
import FeatherDomain
public import FeatherInfrastructure
import WebDomain
import WebInfrastructure

extension Author.Table.Detail {
    func asDomain(metadata: WebDomain.Metadata.Model) -> Author.Model {
        .init(
            id: id,
            name: name,
            excerpt: excerpt,
            content: content,
            profileImageAssetId: profileImageAssetId,
            metadata: metadata,
            createdAt: createdAt,
            updatedAt: updatedAt
        )
    }
}

extension Author.Repository {
    public struct Database: Interface {
        public let context: DatabaseTransactionContext

        public init(context: DatabaseTransactionContext) {
            self.context = context
        }

        public func insert(_ model: Author.Model.New) async throws
            -> Author.Model
        {
            let accessLayer = DatabaseAccessLayer<Author.Table>(
                context: context
            )
            let id = context.idGenerator.generate()
            try await accessLayer.insert(
                Author.Table.Insert(
                    id: id,
                    key: id,
                    name: model.name,
                    notes: model.content,
                    excerpt: model.excerpt,
                    profileImageAssetId: model.profileImageAssetId,
                    content: model.content
                )
            )
            guard
                let author = try await accessLayer.selectFirst(
                    by: \.id,
                    equals: id
                )
            else {
                throw RepositoryError.notFound
            }
            var newMetadata = model.metadata
            try newMetadata.set(referenceID: id)
            let metadata = try await Metadata.Repository
                .Database(context: context)
                .insert(newMetadata)
            return author.asDomain(metadata: metadata)
        }

        public func find(id: String) async throws -> Author.Model? {
            let accessLayer = DatabaseAccessLayer<Author.Table>(
                context: context
            )
            guard
                let author = try await accessLayer.selectFirst(
                    by: \.id,
                    equals: id
                )
            else {
                return nil
            }
            guard
                let metadata = try await Metadata.Repository
                    .Database(context: context)
                    .find(referenceType: "blog.author", referenceId: id)
            else {
                return nil
            }
            return author.asDomain(metadata: metadata)
        }

        public func update(_ model: Author.Model) async throws -> Author.Model {
            let accessLayer = DatabaseAccessLayer<Author.Table>(
                context: context
            )
            try await accessLayer.update(
                Author.Table.Update(
                    key: model.id,
                    name: model.name,
                    notes: model.content,
                    excerpt: model.excerpt,
                    profileImageAssetId: model.profileImageAssetId,
                    content: model.content
                ),
                where: \.id,
                equals: model.id
            )
            guard
                let author = try await accessLayer.selectFirst(
                    by: \.id,
                    equals: model.id
                )
            else {
                throw RepositoryError.notFound
            }
            return author.asDomain(metadata: model.metadata)
        }

        public func delete(ids: [String]) async throws -> [String] {
            try await DatabaseAccessLayer<Author.Table>(context: context)
                .delete(where: \.id, in: ids)
            return ids
        }
    }
}
