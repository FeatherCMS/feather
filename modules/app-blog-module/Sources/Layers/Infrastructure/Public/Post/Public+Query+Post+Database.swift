public import BlogApplication
public import BlogModule
import FeatherApplication
import FeatherDBAL
public import FeatherInfrastructure
public import WebApplication
import WebDomain
public import WebModule

import struct Foundation.Data
import class Foundation.JSONDecoder

private func decodeAssociationIDs(_ value: String) throws -> [String] {
    try JSONDecoder().decode([String].self, from: Data(value.utf8))
}

extension Post.Table.Detail {
    func asDetail(metadata: WebModule.Metadata.Snapshot) throws
        -> Post.Detail.Output
    {
        .init(
            id: id,
            title: title,
            excerpt: excerpt,
            content: content,
            imageAssetId: imageAssetId,
            authorIds: try decodeAssociationIDs(authorIds),
            tagIds: try decodeAssociationIDs(tagIds),
            metadata: metadata,
            createdAt: createdAt,
            updatedAt: updatedAt
        )
    }
}

extension BlogApplication.Public.Post {
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

        public func find(id: String) async throws -> Post.Detail.Output {
            guard
                let row = try await DatabaseAccessLayer<Post.Table>(
                    context: context
                )
                .selectFirst(by: \.id, equals: id)
            else {
                throw RepositoryError.notFound
            }
            guard
                let metadata = try await metadata.find(
                    referenceType: "blog.post",
                    referenceID: id
                )
            else {
                throw RepositoryError.notFound
            }
            return try row.asDetail(metadata: metadata)
        }

        public func list(query: Post.Search.Input.Query) async throws
            -> BlogApplication.Public.Post.List.Query.Output
        {
            let accessLayer = DatabaseAccessLayer<Post.Table>(context: context)
            let page = query.page.normalized()
            let pageIndex = page.number - 1
            let offset =
                pageIndex > Int.max / page.size
                ? Int.max : pageIndex * page.size
            let items = try await accessLayer.select(as: Post.Table.List.self) {
                initial in
                var result = initial
                if let search = query.search {
                    result = result.where(
                        searchText: search,
                        columns: [
                            DatabaseQueryTextColumn<Post.Table>(\.id),
                            DatabaseQueryTextColumn<Post.Table>(\.title),
                            DatabaseQueryTextColumn<Post.Table>(\.excerpt),
                            DatabaseQueryTextColumn<Post.Table>(\.content),
                        ]
                    )
                }
                let orders = query.sort.map { sort in
                    let direction: DatabaseQueryDirection =
                        sort.direction == .asc ? .ascending : .descending
                    return switch sort.field {
                    case .id:
                        DatabaseQueryOrder<Post.Table>(by: \.id, direction)
                    case .title:
                        DatabaseQueryOrder<Post.Table>(by: \.title, direction)
                    case .createdAt:
                        DatabaseQueryOrder<Post.Table>(
                            by: \.createdAt,
                            direction
                        )
                    case .updatedAt:
                        DatabaseQueryOrder<Post.Table>(
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

        public func count(query: Post.Search.Input.Query) async throws -> Int {
            try await DatabaseAccessLayer<Post.Table>(context: context)
                .selectCount { initial in
                    guard let search = query.search else { return initial }
                    return initial.where(
                        searchText: search,
                        columns: [
                            DatabaseQueryTextColumn<Post.Table>(\.id),
                            DatabaseQueryTextColumn<Post.Table>(\.title),
                            DatabaseQueryTextColumn<Post.Table>(\.excerpt),
                            DatabaseQueryTextColumn<Post.Table>(\.content),
                        ]
                    )
                }
        }
    }
}
