//
//  PermissionDatabaseQueries.swift
//  app-system-module
//
//  Created by Tibor Bödecs on 2026. 04. 11.
//

import FeatherApplication
import FeatherContracts
import FeatherDatabase
import FeatherInfrastructure
import SystemApplication

extension PermissionTable.Row {

    var asQueryListItem: PermissionList.Item {
        .init(
            id: id,
            name: name,
            notes: notes,
            createdAt: createdAt,
            updatedAt: updatedAt
        )
    }

    var asDetail: PermissionDetail {
        .init(
            id: id,
            name: name,
            notes: notes,
            createdAt: createdAt,
            updatedAt: updatedAt
        )
    }
}

public struct PermissionDatabaseQueries: PermissionQueries {

    public let context: DatabaseQueryContext

    public init(context: DatabaseQueryContext) {
        self.context = context
    }

    // MARK: -

    private func pageSizeOffset(
        _ page: Search.Page
    ) -> (size: Int, offset: Int) {
        let size = max(1, page.size)
        let number = max(1, page.number)
        return (size, (number - 1) * size)
    }

    private func sortDirectionSQL(
        _ direction: Search.SortDirection
    ) -> String {
        switch direction {
        case .asc:
            "ASC"
        case .desc:
            "DESC"
        }
    }

    private func orderBySystemPermission(
        _ query: PermissionList.Query
    ) -> String {
        let sortParts = query.sort.map { rule -> String in
            let column: String
            switch rule.field {
            case .id:
                column = "id"
            case .name:
                column = "name"
            case .notes:
                column = "notes"
            }
            return "\(column) \(sortDirectionSQL(rule.direction))"
        }
        return (sortParts + ["id ASC"]).joined(separator: ", ")
    }

    // MARK: -

    public func find(
        id: String
    ) async throws -> PermissionDetail {
        let table = PermissionTable(connection: context.connection)
        guard let row = try await table.find(id: id) else {
            fatalError()
        }
        return row.asDetail
    }

    public func list(
        query: PermissionList.Query
    ) async throws -> PermissionList {
        let search = query.search
        let page = pageSizeOffset(query.page)
        let orderBy = orderBySystemPermission(query)

        let table = PermissionTable(connection: context.connection)
        let items =
            try await table.list(
                search: search,
                orderBy: orderBy,
                limit: page.size,
                offset: page.offset
            )
            .map(\.asQueryListItem)

        return .init(items: items)
    }

    public func count(
        query: PermissionList.Query
    ) async throws -> Int {
        let search = query.search

        let table = PermissionTable(connection: context.connection)
        return try await table.count(search: search)
    }

}
