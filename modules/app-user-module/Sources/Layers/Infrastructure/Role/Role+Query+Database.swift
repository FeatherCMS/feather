//
//  Role.Query.Database.swift
//  app-user-module
//
//  Created by Binary Birds on 2026. 06. 18.

import FeatherApplication
import FeatherDBAL
public import FeatherInfrastructure
public import UserApplication
public import UserModule

extension Role.Table.Row {

    var asQueryListItem: Role.Search.Output.Item {
        .init(
            id: id,
            key: key,
            name: name,
            notes: notes,
            createdAt: createdAt,
            updatedAt: updatedAt
        )
    }

    var asDetail: Role.Detail.Output {
        .init(
            id: id,
            key: key,
            name: name,
            notes: notes,
            createdAt: createdAt,
            updatedAt: updatedAt
        )
    }
}

extension Role.Query {
    public struct Database: Role.Query.Interface {

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
            _ query: Role.Search.Input.Query
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
        ) async throws -> Role.Detail.Output {
            let table = Role.Table(connection: context.connection)
            guard let row = try await table.find(id: id) else {
                fatalError()
            }
            return row.asDetail
        }

        public func search(
            query: Role.Search.Input.Query
        ) async throws -> Role.Search.Output {
            let search = query.search
            let page = pageSizeOffset(query.page)
            let orderBy = orderBySystemRole(query)

            let table = Role.Table(connection: context.connection)
            let items =
                try await table.list(
                    search: search,
                    orderBy: orderBy,
                    limit: page.size,
                    offset: page.offset
                )
                .map(\.asQueryListItem)

            let total = try await table.count(search: search)
            return .init(items: items, total: total)
        }

    }
}
