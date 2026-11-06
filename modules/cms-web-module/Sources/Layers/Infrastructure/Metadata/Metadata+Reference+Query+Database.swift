import FeatherDBAL
public import FeatherInfrastructure
public import WebApplication
import WebDomain
public import WebModule

extension Metadata.Table.Detail {
    var asSnapshot: Metadata.Snapshot {
        .init(
            id: id,
            referenceType: referenceType,
            referenceID: referenceID,
            template: template,
            slug: slug,
            publicationDate: publicationDate,
            expirationDate: expirationDate,
            status: .init(rawValue: status) ?? .draft,
            title: titleOverride,
            excerpt: excerptOverride,
            imageURL: imageURLOverride,
            canonicalURL: canonicalURL,
            noIndex: noIndex,
            primaryKeyword: primaryKeyword,
            cssCodeInjection: cssCodeInjection,
            javascriptCodeInjection: javascriptCodeInjection,
            structuredDataCodeInjection: structuredDataCodeInjection,
            templateData: templateData,
            createdAt: createdAt,
            updatedAt: updatedAt
        )
    }
}

extension Metadata.Reference.Query {
    public struct Database: Interface {
        public let context: DatabaseQueryContext

        public init(context: DatabaseQueryContext) {
            self.context = context
        }

        public func find(
            referenceType: String,
            referenceID: String
        ) async throws -> Metadata.Snapshot? {
            try await DatabaseAccessLayer<Metadata.Table>(context: context)
                .selectFirst(as: Metadata.Table.Detail.self) {
                    $0.where(\.referenceType, equals: referenceType)
                        .where(\.referenceID, equals: referenceID)
                        .limit(1)
                }
                .map(\.asSnapshot)
        }
    }
}
