import FeatherApplication
import FeatherDBAL
public import FeatherInfrastructure
public import NewsApplication
public import NewsModule
import WebApplication
import WebInfrastructure
import WebModule

extension Category.Search.Query {
    public struct Database: Interface {
        public let context: DatabaseQueryContext

        public init(context: DatabaseQueryContext) {
            self.context = context
        }

        public func search(
            query: Category.Search.Input.Query
        ) async throws -> Category.Search.Output {
            let matchingMetadataIDs = try await metadataIDs(
                referenceType: "news.category",
                status: query.status
            )
            if matchingMetadataIDs?.isEmpty == true {
                return .init(items: [], total: 0)
            }
            let page = query.page.normalized()
            let pageIndex = page.number - 1
            let offset =
                pageIndex > Int.max / page.size
                ? Int.max
                : pageIndex * page.size
            let accessLayer = DatabaseAccessLayer<Category.Table>(
                context: context
            )

            let rows = try await accessLayer.select(
                as: Category.Table.List.self
            ) {
                var result = $0
                if let search = query.search {
                    result = result.where(
                        searchText: search,
                        columns: [
                            DatabaseQueryTextColumn<Category.Table>(\.id),
                            DatabaseQueryTextColumn<Category.Table>(\.title),
                            DatabaseQueryTextColumn<Category.Table>(\.excerpt),
                            DatabaseQueryTextColumn<Category.Table>(\.content),
                        ]
                    )
                }
                if let matchingMetadataIDs {
                    result = result.where(\.id, in: matchingMetadataIDs)
                }
                let orders = query.sort.map { rule in
                    let direction: DatabaseQueryDirection =
                        rule.direction == .asc ? .ascending : .descending
                    return switch rule.field {
                    case .id:
                        DatabaseQueryOrder<Category.Table>(by: \.id, direction)
                    case .title:
                        DatabaseQueryOrder<Category.Table>(
                            by: \.title,
                            direction
                        )
                    case .createdAt:
                        DatabaseQueryOrder<Category.Table>(
                            by: \.createdAt,
                            direction
                        )
                    case .updatedAt:
                        DatabaseQueryOrder<Category.Table>(
                            by: \.updatedAt,
                            direction
                        )
                    }
                }
                let finalOrders =
                    query.sort.contains(where: { $0.field == .id })
                    ? orders
                    : orders + [.init(by: \.id, .ascending)]
                return result.order(by: finalOrders)
                    .limit(page.size)
                    .offset(offset)
            }
            let total = try await accessLayer.selectCount { initial in
                var result = initial
                if let search = query.search {
                    result = result.where(
                        searchText: search,
                        columns: [
                            DatabaseQueryTextColumn<Category.Table>(\.id),
                            DatabaseQueryTextColumn<Category.Table>(\.title),
                            DatabaseQueryTextColumn<Category.Table>(\.excerpt),
                            DatabaseQueryTextColumn<Category.Table>(\.content),
                        ]
                    )
                }
                if let matchingMetadataIDs {
                    result = result.where(\.id, in: matchingMetadataIDs)
                }
                return result
            }

            return .init(
                items: rows.map {
                    .init(
                        id: $0.id,
                        title: $0.title,
                        excerpt: $0.excerpt,
                        imageAssetId: $0.imageAssetId,
                        createdAt: $0.createdAt,
                        updatedAt: $0.updatedAt
                    )
                },
                total: total
            )
        }

        private func metadataIDs(
            referenceType: String,
            status: String?
        ) async throws -> [String]? {
            guard let status else { return nil }
            return try await WebModule.Metadata.Search.Query.Database(
                context: context
            )
            .matchingReferenceIDs(
                referenceType: referenceType,
                status: status
            )
        }
    }
}
