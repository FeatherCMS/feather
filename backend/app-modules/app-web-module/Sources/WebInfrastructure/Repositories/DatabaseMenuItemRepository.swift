import FeatherDatabase
import Domain
import WebDomain
import Infrastructure

extension MenuItemTable.Row {
    var asDomain: MenuItem {
        .init(
            id: id,
            menuId: menuId,
            label: label,
            url: url,
            priority: priority,
            isBlank: isBlank,
            permission: permission,
            notes: notes,
            createdAt: createdAt,
            updatedAt: updatedAt
        )
    }
}

public struct DatabaseMenuItemRepository: MenuItemRepository {

    public var connection: any DatabaseConnection

    public init(connection: any DatabaseConnection) {
        self.connection = connection
    }

    public func insert(
        _ model: MenuItem.New
    ) async throws -> MenuItem {
        let table = MenuItemTable(connection: connection)
        let saved = try await table.create(
            row: .init(
                id: model.id,
                menuId: model.menuId,
                label: model.label,
                url: model.url,
                priority: model.priority,
                isBlank: model.isBlank,
                permission: model.permission,
                notes: model.notes
            )
        )
        return saved.asDomain
    }

    public func find(
        id: String
    ) async throws -> MenuItem? {
        let table = MenuItemTable(connection: connection)
        return try await table.find(id: id)?.asDomain
    }

    public func update(
        _ model: MenuItem
    ) async throws -> MenuItem {
        let table = MenuItemTable(connection: connection)
        let updated = try await table.update(
            id: model.id,
            row: .init(
                id: model.id,
                menuId: model.menuId,
                label: model.label,
                url: model.url,
                priority: model.priority,
                isBlank: model.isBlank,
                permission: model.permission,
                notes: model.notes,
                createdAt: model.createdAt,
                updatedAt: model.updatedAt
            )
        )
        return updated.asDomain
    }

    public func delete(
        id: String
    ) async throws -> Bool {
        let table = MenuItemTable(connection: connection)
        return try await table.delete(id: id)
    }
}
