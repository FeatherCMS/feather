import FeatherDBAL
public import FeatherInfrastructure
public import NewsApplication
import NewsModule
public import WebApplication
public import WebModule

extension NewsApplication.Public.Article.Detail.Query {
    public struct Database: Interface {
        public let context: DatabaseQueryContext
        public let metadata:
            any WebModule.Metadata.Resolve.Detail.Query.Interface

        public init(
            context: DatabaseQueryContext,
            metadata: any WebModule.Metadata.Resolve.Detail.Query.Interface
        ) {
            self.context = context
            self.metadata = metadata
        }

        public func findCategories(
            ids: [String]
        ) async throws -> Output {
            guard !ids.isEmpty else { return .init(items: []) }
            let rows = try await DatabaseAccessLayer<Category.Table>(
                context: context
            )
            .select { $0.where(\.id, in: ids).order(by: \.id) }
            let details = try await metadata.resolveDetails(
                referenceType: "news.category",
                referenceIDs: Array(Set(ids))
            )
            var metadataByID: [String: WebModule.Metadata.Snapshot] = [:]
            for detail in details {
                precondition(
                    metadataByID.updateValue(
                        detail,
                        forKey: detail.referenceID
                    ) == nil
                )
            }
            let items = rows.compactMap {
                row -> Item? in
                guard let detail = metadataByID[row.id] else { return nil }
                return .init(
                    id: row.id,
                    title: row.title,
                    excerpt: row.excerpt,
                    imageAssetId: row.imageAssetId,
                    metadata: detail
                )
            }
            return .init(items: items)
        }
    }
}
