import RedirectApplication
import FeatherDatabase
import Application
import Infrastructure

extension RuleTable.Row {

    var asQueryListItem: RuleList.Item {
        .init(
            id: id,
            source: source,
            destination: destination,
            statusCode: statusCode,
            notes: notes,
            createdAt: createdAt,
            updatedAt: updatedAt
        )
    }

    var asDetail: RuleDetail {
        .init(
            id: id,
            source: source,
            destination: destination,
            statusCode: statusCode,
            notes: notes,
            createdAt: createdAt,
            updatedAt: updatedAt
        )
    }
}

public struct DatabaseRuleQueries: RuleQueries {

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

    func orderByRedirectRule(
        _ query: RuleList.Query
    ) -> String {
        let sortParts = query.sort.map { rule -> String in
            let column: String
            switch rule.field {
            case .id:
                column = "id"
            case .source:
                column = "source"
            case .destination:
                column = "destination"
            case .statusCode:
                column = "status_code"
            case .notes:
                column = "notes"
            }
            return "\(column) \(sortDirectionSQL(rule.direction))"
        }
        return (sortParts + ["id ASC"]).joined(separator: ", ")
    }

    public func find(
        id: String
    ) async throws -> RuleDetail {
        let table = RuleTable(connection: connection)
        guard let row = try await table.find(id: id) else {
            throw RepositoryError.notFound
        }
        return row.asDetail
    }

    public func find(
        source: String
    ) async throws -> RuleDetail? {
        let table = RuleTable(connection: connection)
        return try await table.find(source: source)?.asDetail
    }

    public func list(
        query: RuleList.Query
    ) async throws -> RuleList {
        let page = pageSizeOffset(query.page)
        let table = RuleTable(connection: connection)
        let items =
            try await table.list(
                search: query.search,
                statusCode: query.statusCode,
                orderBy: orderByRedirectRule(query),
                limit: page.size,
                offset: page.offset
            )
            .map(\.asQueryListItem)

        return .init(items: items)
    }

    public func count(
        query: RuleList.Query
    ) async throws -> Int {
        let table = RuleTable(connection: connection)
        return try await table.count(
            search: query.search,
            statusCode: query.statusCode
        )
    }
}
