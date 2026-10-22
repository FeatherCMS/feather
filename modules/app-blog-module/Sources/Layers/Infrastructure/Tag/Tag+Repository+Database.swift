public import BlogDomain
public import BlogModule
import FeatherDBAL
import FeatherDomain
public import FeatherInfrastructure
import WebDomain
import WebInfrastructure

extension Tag.Table.Detail {
    func asDomain(metadata: WebDomain.Metadata.Model) -> Tag.Model {
        .init(
            id: id,
            title: title,
            excerpt: excerpt,
            content: content,
            imageAssetId: imageAssetId,
            metadata: metadata,
            createdAt: createdAt,
            updatedAt: updatedAt
        )
    }
}

extension Tag.Repository {
    public struct Database: Interface {
        public let context: DatabaseTransactionContext

        public init(context: DatabaseTransactionContext) {
            self.context = context
        }

        public func insert(_ model: Tag.Model.New) async throws -> Tag.Model {
            let accessLayer = DatabaseAccessLayer<Tag.Table>(context: context)
            let id = context.idGenerator.generate()
            try await accessLayer.insert(
                Tag.Table.Insert(
                    id: id,
                    title: model.title,
                    excerpt: model.excerpt,
                    content: model.content,
                    imageAssetId: model.imageAssetId
                )
            )
            guard
                let tag = try await accessLayer.selectFirst(
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
            return tag.asDomain(metadata: metadata)
        }

        public func find(id: String) async throws -> Tag.Model? {
            let accessLayer = DatabaseAccessLayer<Tag.Table>(context: context)
            guard
                let tag = try await accessLayer.selectFirst(
                    by: \.id,
                    equals: id
                )
            else {
                return nil
            }
            guard
                let metadata = try await Metadata.Repository
                    .Database(context: context)
                    .find(referenceType: "blog.tag", referenceId: id)
            else {
                return nil
            }
            return tag.asDomain(metadata: metadata)
        }

        public func update(_ model: Tag.Model) async throws -> Tag.Model {
            let accessLayer = DatabaseAccessLayer<Tag.Table>(context: context)
            try await accessLayer.update(
                Tag.Table.Update(
                    title: model.title,
                    excerpt: model.excerpt,
                    content: model.content,
                    imageAssetId: model.imageAssetId
                ),
                where: \.id,
                equals: model.id
            )
            guard
                let tag = try await accessLayer.selectFirst(
                    by: \.id,
                    equals: model.id
                )
            else {
                throw RepositoryError.notFound
            }
            return tag.asDomain(metadata: model.metadata)
        }

        public func delete(ids: [String]) async throws -> [String] {
            try await DatabaseAccessLayer<Tag.Table>(context: context)
                .delete(where: \.id, in: ids)
            return ids
        }
    }
}
