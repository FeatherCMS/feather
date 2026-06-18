import WebApplication
import FeatherDatabase
import Application
import Infrastructure
import WebApplication
import WebDomain

extension PageTable.Row {

    var placeholderMetadata: MetadataDetail {
        .init(
            referenceType: "web.page",
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

    var asQueryListItem: PageList.Item {
        .init(
            id: id,
            title: title,
            excerpt: excerpt,
            imageAssetId: imageAssetId,
            createdAt: createdAt,
            updatedAt: updatedAt
        )
    }

    var asDetail: PageDetail {
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

public struct DatabasePageQueries: PageQueries {

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

    func orderByPage(
        _ query: PageList.Query
    ) -> String {
        let sortParts = query.sort.map { page -> String in
            let column: String
            switch page.field {
            case .id:
                column = "id"
            case .title:
                column = "title"
            case .createdAt:
                column = "created_at"
            case .updatedAt:
                column = "updated_at"
            }
            return "\(column) \(sortDirectionSQL(page.direction))"
        }
        return (sortParts + ["id ASC"]).joined(separator: ", ")
    }

    public func find(
        id: String
    ) async throws -> PageDetail {
        let table = PageTable(connection: connection)
        guard let row = try await table.find(id: id) else {
            throw RepositoryError.notFound
        }
        return row.asDetail
    }

    public func list(
        query: PageList.Query
    ) async throws -> PageList {
        let page = pageSizeOffset(query.page)
        let table = PageTable(connection: connection)
        let items =
            try await table.list(
                search: query.search,
                orderBy: orderByPage(query),
                limit: page.size,
                offset: page.offset
            )
            .map(\.asQueryListItem)

        return .init(items: items)
    }

    public func count(
        query: PageList.Query
    ) async throws -> Int {
        let table = PageTable(connection: connection)
        return try await table.count(search: query.search)
    }
}
