public import BlogApplication
public import BlogModule
import FeatherApplication
import FeatherDBAL
public import FeatherInfrastructure
public import WebApplication
public import WebDomain

extension Tag.Table.List {
    var asQueryItem: Tag.List.Output.Item {
        .init(
            id: id,
            title: title,
            excerpt: excerpt,
            imageAssetId: imageAssetId,
            createdAt: createdAt,
            updatedAt: updatedAt
        )
    }
}

extension Tag.Table.Detail {
    func asDetail(metadata: MetadataDetail) -> Tag.Detail.Output {
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

extension Public.Query.TagContent {
    public struct Database: Interface {
        public let context: DatabaseQueryContext
        public let metadata: any Metadata.Query.Interface

        public init(
            context: DatabaseQueryContext,
            metadata: any Metadata.Query.Interface
        ) {
            self.context = context
            self.metadata = metadata
        }

        public func find(id: String) async throws -> Tag.Detail.Output {
            guard
                let row = try await DatabaseAccessLayer<Tag.Table>(
                    context: context
                )
                .selectFirst(by: \.id, equals: id)
            else {
                throw RepositoryError.notFound
            }
            guard
                let metadata = try await metadata.find(
                    referenceType: "blog.tag",
                    referenceID: id
                )
            else {
                throw RepositoryError.notFound
            }
            return row.asDetail(metadata: metadata)
        }

        public func list(query: Tag.Search.Input.Query) async throws
            -> Tag.List.Output
        {
            let accessLayer = DatabaseAccessLayer<Tag.Table>(context: context)
            let page = query.page.normalized()
            let pageIndex = page.number - 1
            let offset =
                pageIndex > Int.max / page.size
                ? Int.max : pageIndex * page.size
            let items = try await accessLayer.select(as: Tag.Table.List.self) {
                initial in
                var result = initial
                if let search = query.search {
                    result = result.where(
                        searchText: search,
                        columns: [
                            DatabaseQueryTextColumn<Tag.Table>(\.id),
                            DatabaseQueryTextColumn<Tag.Table>(\.title),
                            DatabaseQueryTextColumn<Tag.Table>(\.excerpt),
                            DatabaseQueryTextColumn<Tag.Table>(\.content),
                        ]
                    )
                }
                let orders = query.sort.map { sort in
                    let direction: DatabaseQueryDirection =
                        sort.direction == .asc ? .ascending : .descending
                    return switch sort.field {
                    case .id: DatabaseQueryOrder<Tag.Table>(by: \.id, direction)
                    case .title:
                        DatabaseQueryOrder<Tag.Table>(by: \.title, direction)
                    case .createdAt:
                        DatabaseQueryOrder<Tag.Table>(
                            by: \.createdAt,
                            direction
                        )
                    case .updatedAt:
                        DatabaseQueryOrder<Tag.Table>(
                            by: \.updatedAt,
                            direction
                        )
                    }
                }
                return
                    result
                    .order(by: orders + [.init(by: \.id, .ascending)])
                    .limit(page.size)
                    .offset(offset)
            }
            return .init(items: items.map(\.asQueryItem))
        }

        public func count(query: Tag.Search.Input.Query) async throws -> Int {
            try await DatabaseAccessLayer<Tag.Table>(context: context)
                .selectCount { initial in
                    guard let search = query.search else { return initial }
                    return initial.where(
                        searchText: search,
                        columns: [
                            DatabaseQueryTextColumn<Tag.Table>(\.id),
                            DatabaseQueryTextColumn<Tag.Table>(\.title),
                            DatabaseQueryTextColumn<Tag.Table>(\.excerpt),
                            DatabaseQueryTextColumn<Tag.Table>(\.content),
                        ]
                    )
                }
        }
    }
}
