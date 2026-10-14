//
//  VariableDatabaseQueries.swift
//  app-system-module
//
//  Created by Tibor Bödecs on 2026. 04. 11.
//

import FeatherApplication
public import FeatherInfrastructure
public import SystemApplication

extension VariableTable.Row.List {

    var asQueryListItem: VariableList.Item {
        .init(
            id: id,
            key: key,
            value: value,
            name: name,
            notes: notes,
            createdAt: createdAt,
            updatedAt: updatedAt
        )
    }

}

extension VariableTable.Row.Detail {
    var asDetail: VariableDetail {
        .init(
            id: id,
            key: key,
            value: value,
            name: name,
            notes: notes,
            createdAt: createdAt,
            updatedAt: updatedAt
        )
    }
}

public struct VariableDatabaseQueries: VariableQueries {

    public let context: DatabaseQueryContext

    public init(context: DatabaseQueryContext) {
        self.context = context
    }

    func databaseQuery(
        _ query: VariableList.Query
    ) -> DatabaseTableQuery {
        var databaseQuery = DatabaseTableQuery()

        if let ids = query.ids, !ids.isEmpty {
            databaseQuery = databaseQuery.filter(
                VariableTable.Fields.id,
                isIn: ids
            )
        }

        if let search = query.search {
            databaseQuery = databaseQuery.search(
                search,
                in: [
                    VariableTable.Fields.key,
                    VariableTable.Fields.name,
                    VariableTable.Fields.value,
                    VariableTable.Fields.notes
                ]
            )
        }

        var orderings: [DatabaseTableQuery.Ordering] = []
        for rule in query.sort {
            let field: any DatabaseFieldRepresentable
            switch rule.field {
            case .key:
                field = VariableTable.Fields.key
            case .name:
                field = VariableTable.Fields.name
            case .value:
                field = VariableTable.Fields.value
            case .notes:
                field = VariableTable.Fields.notes
            }
            let direction: DatabaseTableQuery.SortDirection
            switch rule.direction {
            case .asc:
                direction = .ascending
            case .desc:
                direction = .descending
            }
            orderings.append(
                .init(
                    field: field,
                    direction: direction
                )
            )
        }

        if !query.sort.contains(where: { $0.field == .key }) {
            orderings.append(
                .init(
                    field: VariableTable.Fields.key,
                    direction: .ascending
                )
            )
        }

        databaseQuery = databaseQuery.orderBy(orderings)

        let pageSize = max(1, query.page.size)
        let pageNumber = max(1, query.page.number)
        return databaseQuery
            .limit(pageSize)
            .offset((pageNumber - 1) * pageSize)
    }

    // MARK: -

    public func find(
        id: String
    ) async throws -> VariableDetail {
        let table = VariableTable(connection: context.connection)
        guard let row = try await table.findFirst(
            by: VariableTable.Fields.id,
            equals: id,
            returning: VariableTable.Row.Detail.self
        ) else {
            throw RepositoryError.notFound
        }
        return row.asDetail
    }

    public func get(
        _ key: String
    ) async throws -> String? {
        let table = VariableTable(connection: context.connection)
        let row = try await table.findFirst(
            by: VariableTable.Fields.key,
            equals: key,
            returning: VariableTable.Row.Detail.self
        )
        return row?.value
    }

    public func list(
        query: VariableList.Query
    ) async throws -> VariableList {
        let table = VariableTable(connection: context.connection)
        let items =
            try await table.list(
                databaseQuery(query),
                returning: VariableTable.Row.List.self
            )
            .map(\.asQueryListItem)

        return .init(items: items)
    }

    public func count(
        query: VariableList.Query
    ) async throws -> Int {
        let table = VariableTable(connection: context.connection)
        return try await table.count(databaseQuery(query))
    }
}
