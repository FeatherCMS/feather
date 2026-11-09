import FeatherDatabase
import FeatherInfrastructure
import WebApplication
import WebDomain
import WebInfrastructure
import WebModule

struct FeatherMainMenuAuthItemsMigration: DatabaseMigration {
    let context: DatabaseTransactionContext

    var connection: any DatabaseConnection {
        context.connection
    }

    func apply(
        on connection: any DatabaseConnection
    ) async throws {
        let queryContext = DatabaseQueryContext(
            platform: context.platform,
            connection: connection,
            idGenerator: context.idGenerator
        )
        let menuQuery = Menu.Public.Detail.Query.Database(
            context: queryContext
        )
        guard let menu = try await menuQuery.findMenu(key: "main") else {
            return
        }

        let existingItems = try await menuQuery.listMenuItems(
            menuId: menu.id
        )
        let repository = MenuItem.Repository.Database(
            context: DatabaseTransactionContext(
                platform: context.platform,
                connection: connection,
                idGenerator: context.idGenerator
            )
        )

        for item in FeatherMenuSeedEventHandlers.mainMenuItems
        where !existingItems.contains(where: { $0.url == item.url }) {
            _ = try await repository.insert(
                MenuItem.Model.create(
                    menuId: menu.id,
                    label: item.label,
                    url: item.url,
                    priority: item.priority,
                    isBlank: item.isBlank,
                    permission: item.permission,
                    authentication: MenuItem.Model.Authentication(
                        rawValue: item.authentication.rawValue
                    ) ?? .any,
                    notes: item.notes
                )
            )
        }
    }
}
