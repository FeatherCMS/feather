import BlogApplication
import FeatherDatabase
import Application
import Infrastructure
import WebApplication
import WebDomain

extension TagTable.Row {

    var placeholderMetadata: MetadataDetail {
        .init(
            referenceType: "blog.tag",
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

    var asQueryListItem: TagList.Item {
        .init(
            id: id,
            title: title,
            excerpt: excerpt,
            imageAssetId: imageAssetId,
            createdAt: createdAt,
            updatedAt: updatedAt
        )
    }

    var asDetail: TagDetail {
        .init(
            id: id,
            title: title,
            excerpt: excerpt,
            content: content,
            imageAssetId: imageAssetId,
            metadata: placeholderMetadata,
            createdAt: createdAt,
            updatedAt: updatedAt
        )
    }
}

public struct DatabaseTagQueries: TagQueries {

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

    func orderByTag(
        _ query: TagList.Query
    ) -> String {
        let sortParts = query.sort.map { tag -> String in
            let column: String
            switch tag.field {
            case .id:
                column = "id"
            case .title:
                column = "title"
            case .createdAt:
                column = "created_at"
            case .updatedAt:
                column = "updated_at"
            }
            return "\(column) \(sortDirectionSQL(tag.direction))"
        }
        return (sortParts + ["id ASC"]).joined(separator: ", ")
    }

    public func find(
        id: String
    ) async throws -> TagDetail {
        let table = TagTable(connection: connection)
        guard let row = try await table.find(id: id) else {
            throw RepositoryError.notFound
        }
        return row.asDetail
    }

    public func list(
        query: TagList.Query
    ) async throws -> TagList {
        let page = pageSizeOffset(query.page)
        let table = TagTable(connection: connection)
        let items =
            try await table.list(
                search: query.search,
                orderBy: orderByTag(query),
                limit: page.size,
                offset: page.offset
            )
            .map(\.asQueryListItem)

        return .init(items: items)
    }

    public func count(
        query: TagList.Query
    ) async throws -> Int {
        let table = TagTable(connection: connection)
        return try await table.count(search: query.search)
    }
}
