import FeatherDBAL
public import FeatherInfrastructure
public import WebApplication
import WebDomain
public import WebModule

extension Page.Detail.Query {
    public struct Database:
        Interface,
        Public.Interface
    {
        public let context: DatabaseQueryContext
        public let metadata: any Metadata.Reference.Query.Interface

        public init(
            context: DatabaseQueryContext,
            metadata: any Metadata.Reference.Query.Interface
        ) {
            self.context = context
            self.metadata = metadata
        }

        public func find(id: String) async throws -> Page.Model {
            guard
                let page = try await DatabaseAccessLayer<Page.Table>(
                    context: context
                )
                .selectFirst(by: \.id, equals: id)
            else {
                throw RepositoryError.notFound
            }
            guard
                let metadata = try await metadata.find(
                    referenceType: "web.page",
                    referenceID: id
                )
            else {
                throw RepositoryError.notFound
            }
            let metadataModel = Metadata.Model(
                id: metadata.id,
                reference: .identified(
                    .init(
                        type: metadata.referenceType,
                        id: metadata.referenceID
                    )
                ),
                template: metadata.template,
                slug: metadata.slug,
                publicationDate: metadata.publicationDate,
                expirationDate: metadata.expirationDate,
                status: metadata.status,
                title: metadata.title,
                excerpt: metadata.excerpt,
                imageURL: metadata.imageURL,
                canonicalURL: metadata.canonicalURL,
                noIndex: metadata.noIndex,
                primaryKeyword: metadata.primaryKeyword,
                cssCodeInjection: metadata.cssCodeInjection,
                javascriptCodeInjection: metadata.javascriptCodeInjection,
                structuredDataCodeInjection:
                    metadata.structuredDataCodeInjection,
                createdAt: metadata.createdAt,
                updatedAt: metadata.updatedAt
            )
            return Page.Model(
                id: page.id,
                title: page.title,
                excerpt: page.excerpt,
                content: page.content,
                imageAssetId: page.imageAssetId,
                metadata: metadataModel,
                createdAt: page.createdAt,
                updatedAt: page.updatedAt
            )
        }
    }
}
