import FeatherDBAL
public import FeatherInfrastructure
import WebDomain
public import WebApplication
public import WebModule

extension WebRoute.Resolve.Query {
    public struct Database: Interface {
        public let context: DatabaseQueryContext

        public init(context: DatabaseQueryContext) {
            self.context = context
        }

        public func resolve(slug: String) async throws -> Metadata.Snapshot? {
            try await DatabaseAccessLayer<Metadata.Table>(context: context)
                .selectFirst(by: \.slug, equals: slug)
                .map {
                    .init(
                        id: $0.id,
                        referenceType: $0.referenceType,
                        referenceID: $0.referenceID,
                        template: $0.template,
                        slug: $0.slug,
                        publicationDate: $0.publicationDate,
                        expirationDate: $0.expirationDate,
                        status: .init(rawValue: $0.status) ?? .draft,
                        title: $0.titleOverride,
                        excerpt: $0.excerptOverride,
                        imageURL: $0.imageURLOverride,
                        canonicalURL: $0.canonicalURL,
                        noIndex: $0.noIndex,
                        primaryKeyword: $0.primaryKeyword,
                        cssCodeInjection: $0.cssCodeInjection,
                        javascriptCodeInjection: $0.javascriptCodeInjection,
                        structuredDataCodeInjection: $0
                            .structuredDataCodeInjection,
                        createdAt: $0.createdAt,
                        updatedAt: $0.updatedAt
                    )
                }
        }
    }
}
