//
//  MagicLinkDatabaseQueries.swift
//  app-auth-module
//
//  Created by Binary Birds on 2026. 06. 18.

import AuthApplication
import FeatherApplication
import FeatherContracts
import FeatherDatabase
import FeatherInfrastructure

extension MagicLinkTable.Row {

    var asQueryListItem: MagicLinkList.Item {
        .init(
            id: id,
            authEmailId: authEmailId,
            token: token,
            expiresAt: expiresAt,
            isPersistent: isPersistent,
            isUsed: isUsed,
            createdAt: createdAt,
            updatedAt: updatedAt
        )
    }

    var asDetail: MagicLinkDetail {
        .init(
            id: id,
            authEmailId: authEmailId,
            token: token,
            expiresAt: expiresAt,
            isPersistent: isPersistent,
            isUsed: isUsed,
            createdAt: createdAt,
            updatedAt: updatedAt
        )
    }
}

public struct MagicLinkDatabaseQueries: MagicLinkQueries {

    public let context: DatabaseQueryContext

    public init(context: DatabaseQueryContext) {
        self.context = context
    }

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

    private func orderBySystemMagicLink(
        _ query: MagicLinkList.Query
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

    public func find(
        id: String
    ) async throws -> MagicLinkDetail {
        let table = MagicLinkTable(connection: context.connection)
        guard let row = try await table.find(id: id) else {
            throw RepositoryError.notFound
        }
        return row.asDetail
    }

    public func list(
        query: MagicLinkList.Query
    ) async throws -> MagicLinkList {
        let search = query.search
        let page = pageSizeOffset(query.page)
        let orderBy = orderBySystemMagicLink(query)

        let table = MagicLinkTable(connection: context.connection)
        let items =
            try await table.list(
                userId: query.userId,
                search: search,
                orderBy: orderBy,
                limit: page.size,
                offset: page.offset
            )
            .map(\.asQueryListItem)

        return .init(items: items)
    }

    public func count(
        query: MagicLinkList.Query
    ) async throws -> Int {
        let table = MagicLinkTable(connection: context.connection)
        return try await table.count(
            userId: query.userId,
            search: query.search
        )
    }
}
