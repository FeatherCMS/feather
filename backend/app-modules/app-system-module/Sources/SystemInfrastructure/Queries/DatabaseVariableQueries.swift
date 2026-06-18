//
//  File.swift
//  app-system-module
//
//  Created by Tibor Bödecs on 2026. 04. 11..
//

import SystemApplication
import FeatherDatabase
import Application

extension VariableTable.Row {

    var asQueryListItem: VariableList.Item {
        .init(
            id: id,
            name: name,
            value: value,
            notes: notes,
            createdAt: createdAt,
            updatedAt: updatedAt
        )
    }

    var asDetail: VariableDetail {
        .init(
            id: id,
            name: name,
            value: value,
            notes: notes,
            createdAt: createdAt,
            updatedAt: updatedAt
        )
    }
}

public struct DatabaseVariableQueries: VariableQueries {

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

    func orderBySystemVariable(
        _ query: VariableList.Query
    ) -> String {
        let sortParts = query.sort.map { rule -> String in
            let column: String
            switch rule.field {
            case .id:
                column = "id"
            case .name:
                column = "name"
            case .value:
                column = "value"
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
    ) async throws -> VariableDetail {
        let table = VariableTable(connection: connection)
        guard let row = try await table.find(id: id) else {
            fatalError()
        }
        return row.asDetail
    }

    public func list(
        query: VariableList.Query
    ) async throws -> VariableList {
        let search = query.search
        let page = pageSizeOffset(query.page)
        let orderBy = orderBySystemVariable(query)

        let table = VariableTable(connection: connection)
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
        query: VariableList.Query
    ) async throws -> Int {
        let search = query.search
        let table = VariableTable(connection: connection)
        return try await table.count(search: search)
    }
}
