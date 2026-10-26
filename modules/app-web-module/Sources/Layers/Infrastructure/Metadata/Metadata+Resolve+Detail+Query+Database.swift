import FeatherDBAL
public import FeatherInfrastructure
public import WebApplication
import WebDomain
public import WebModule

extension Metadata.Table.Detail {
    var asResolvedSnapshot: Metadata.Snapshot {
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
            createdAt: createdAt,
            updatedAt: updatedAt
        )
    }
}

extension Metadata.Resolve.Detail.Query {
    public struct Database: Interface {
        public let context: DatabaseQueryContext

        public init(context: DatabaseQueryContext) {
            self.context = context
        }

        public func resolveDetails(
            referenceType: String,
            referenceIDs: [String]
        ) async throws -> [Metadata.Snapshot] {
            guard !referenceIDs.isEmpty else { return [] }
            let rows = try await DatabaseAccessLayer<Metadata.Table>(
                context: context
            )
            .select(as: Metadata.Table.Detail.self) {
                $0.where(\.referenceType, equals: referenceType)
                    .where(\.referenceID, in: referenceIDs)
                    .order(by: \.referenceID, .ascending)
            }
            return rows.map(\.asResolvedSnapshot)
        }
    }
}
