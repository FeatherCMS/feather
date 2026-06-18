import BlogApplication
import FeatherDatabase
import Application
import Infrastructure
import WebApplication
import WebDomain

extension PostTable.Row {

    var placeholderMetadata: MetadataDetail {
        .init(
            referenceType: "blog.post",
            referenceID: id,
            id: "metadata_\(id)",
            slug: id,
            publicationDate: nil,
            expirationDate: nil,
            status: .draft,
            title: nil,
            excerpt: nil,
            imageURL: nil,
            canonicalURL: "",
            noIndex: false,
            primaryKeyword: "",
            cssCodeInjection: "",
            javascriptCodeInjection: "",
            structuredDataCodeInjection: "",
            createdAt: createdAt,
            updatedAt: updatedAt
        )
    }

    var asQueryListItem: PostList.Item {
        .init(
            id: id,
            title: title,
            excerpt: excerpt,
            imageAssetId: imageAssetId,
            createdAt: createdAt,
            updatedAt: updatedAt
        )
    }

    var asDetail: PostDetail {
        .init(
            id: id,
            title: title,
            excerpt: excerpt,
            content: content,
            imageAssetId: imageAssetId,
            authorIds: authorIds,
            tagIds: tagIds,
            metadata: placeholderMetadata,
            createdAt: createdAt,
            updatedAt: updatedAt
        )
    }
}

public struct DatabasePostQueries: PostQueries {

    public var connection: any DatabaseConnection

    public init(connection: any DatabaseConnection) {
        self.connection = connection
    }

    func pageSizeOffset(
        _ page: Search.Page
    ) -> (size: Int, offset: Int) {
        let size = max(1, page.size)
        let number = max(1, page.number)
        return (size, (number - 1) * size)
    }

    func sortDirectionSQL(
        _ direction: Search.SortDirection
    ) -> String {
        switch direction {
        case .asc:
            "ASC"
        case .desc:
            "DESC"
        }
    }

    func orderByPost(
        _ query: PostList.Query
    ) -> String {
        let sortParts = query.sort.map { post -> String in
            let column: String
            switch post.field {
            case .id:
                column = "id"
            case .title:
                column = "title"
            case .createdAt:
                column = "created_at"
            case .updatedAt:
                column = "updated_at"
            }
            return "\(column) \(sortDirectionSQL(post.direction))"
        }
        return (sortParts + ["id ASC"]).joined(separator: ", ")
    }

    public func find(
        id: String
    ) async throws -> PostDetail {
        let table = PostTable(connection: connection)
        guard let row = try await table.find(id: id) else {
            throw RepositoryError.notFound
        }
        return row.asDetail
    }

    public func list(
        query: PostList.Query
    ) async throws -> PostList {
        let page = pageSizeOffset(query.page)
        let table = PostTable(connection: connection)
        let items =
            try await table.list(
                search: query.search,
                orderBy: orderByPost(query),
                limit: page.size,
                offset: page.offset
            )
            .map(\.asQueryListItem)

        return .init(items: items)
    }

    public func count(
        query: PostList.Query
    ) async throws -> Int {
        let table = PostTable(connection: connection)
        return try await table.count(search: query.search)
    }
}
