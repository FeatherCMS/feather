//
//  SessionDatabaseQueries.swift
//  app-auth-module
//
//  Created by Binary Birds on 2026. 06. 18.

import AuthApplication
import FeatherApplication
import FeatherContracts
import FeatherDatabase
import FeatherInfrastructure

import struct Foundation.Date

extension SessionTable.Row {

    var asQueryListItem: SessionList.Item {
        .init(
            id: id,
            token: token,
            identityId: identityId,
            authenticationType: authenticationType,
            authenticationReference: authenticationReference,
            expiresAt: expiresAt.timeIntervalSince1970,
            isPersistent: isPersistent,
            createdAt: createdAt,
            updatedAt: updatedAt
        )
    }
}

public struct SessionDatabaseQueries: SessionQueries {

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

    public func find(
        id: String
    ) async throws -> SessionDetail {
        let table = SessionTable(connection: context.connection)
        guard let row = try await table.find(id: id) else {
            throw RepositoryError.notFound
        }
        return .init(
            id: row.id,
            token: row.token,
            identityId: row.identityId,
            authenticationType: row.authenticationType,
            authenticationReference: row.authenticationReference,
            expiresAt: row.expiresAt.timeIntervalSince1970,
            isPersistent: row.isPersistent,
            createdAt: row.createdAt,
            updatedAt: row.updatedAt
        )
    }

    public func list(
        query: SessionList.Query
    ) async throws -> SessionList {
        let table = SessionTable(connection: context.connection)
        let rows = try await table.list()

        let searched = rows.filter { row in
            if let identityId = query.identityId,
                row.identityId != identityId
            {
                return false
            }
            guard let search = query.search?.lowercased(), !search.isEmpty
            else {
                return true
            }
            return row.id.lowercased().contains(search)
                || row.token.lowercased().contains(search)
                || row.identityId.lowercased().contains(search)
                || String(row.expiresAt.timeIntervalSince1970).contains(search)
                || String(row.isPersistent).lowercased().contains(search)
        }

        let sorted = searched.sorted { lhs, rhs in
            let direction = query.sort.first?.direction ?? .asc
            switch direction {
            case .asc:
                return lhs.id < rhs.id
            case .desc:
                return lhs.id > rhs.id
            }
        }

        let page = pageSizeOffset(query.page)
        let paged = Array(sorted.dropFirst(page.offset).prefix(page.size))
        let items = paged.map(\.asQueryListItem)

        return .init(items: items)
    }
}
