public import BlogApplication
public import BlogModule
import FeatherApplication
import FeatherDBAL
public import FeatherInfrastructure
public import WebApplication
public import WebModule

extension Tag.Table.Detail {
    func asDetail(metadata: WebModule.Metadata.Snapshot)
        -> Tag.Detail.Output
    {
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

extension BlogApplication.Public.Tag {
    public struct Database: Detail.Query.Interface, List.Query.Interface {
        public let context: DatabaseQueryContext
        public let metadata: any WebModule.Metadata.Reference.Query.Interface

        public init(
            context: DatabaseQueryContext,
            metadata: any WebModule.Metadata.Reference.Query.Interface
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
            -> BlogApplication.Public.Tag.List.Query.Output
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
            return .init(
                items: items.map {
                    .init(
                        id: $0.id,
                        title: $0.title,
                        excerpt: $0.excerpt,
                        imageAssetId: $0.imageAssetId
                    )
                }
            )
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
