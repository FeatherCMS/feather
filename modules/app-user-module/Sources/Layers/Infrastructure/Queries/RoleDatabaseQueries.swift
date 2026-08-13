//
//  RoleDatabaseQueries.swift
//  app-user-module
//
//  Created by Binary Birds on 2026. 06. 18.

import FeatherApplication
import FeatherContracts
import FeatherDatabase
import FeatherInfrastructure
import UserApplication

extension RoleTable.Row {

    var asQueryListItem: RoleList.Item {
        .init(
            id: id,
            name: name,
            notes: notes,
            createdAt: createdAt,
            updatedAt: updatedAt
        )
    }

    var asDetail: RoleDetail {
        .init(
            id: id,
            name: name,
            notes: notes,
            createdAt: createdAt,
            updatedAt: updatedAt
        )
    }
}

public struct RoleDatabaseQueries: RoleQueries {

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

    private func orderBySystemRole(
        _ query: RoleList.Query
    ) -> String {
        let sortParts = query.sort.map { rule -> String in
            let column: String
            switch rule.field {
            case .id:
                column = "id"
            }
            return "\(column) \(sortDirectionSQL(rule.direction))"
        }
        return (sortParts + ["id ASC"]).joined(separator: ", ")
    }

    // MARK: -

    public func getBy(
        id: String
    ) async throws -> RoleDetail {
        let table = RoleTable(connection: context.connection)
        guard let row = try await table.find(id: id) else {
            fatalError()
        }
        return row.asDetail
    }

    public func list(
        query: RoleList.Query
    ) async throws -> RoleList {
        let search = query.search
        let page = pageSizeOffset(query.page)
        let orderBy = orderBySystemRole(query)

        let table = RoleTable(connection: context.connection)
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
        query: RoleList.Query
    ) async throws -> Int {
        let search = query.search

        let table = RoleTable(connection: context.connection)
        return try await table.count(search: search)
    }

}
