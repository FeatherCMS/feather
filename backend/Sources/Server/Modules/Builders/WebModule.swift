import Application
import Infrastructure
import WebInfrastructure
import SystemInfrastructure
import WebApplication

struct WebModule: Sendable {

    private let infrastructure: AppInfrastructure
    private let authorizer: any Authorizer

    init(
        infrastructure: AppInfrastructure,
        authorizer: any Authorizer
    ) {
        self.infrastructure = infrastructure
        self.authorizer = authorizer
    }
}

extension WebModule {

    func makeGetPublicSettings() -> GetPublicSettings {
        let query = DatabaseQueryExecutor(
            database: infrastructure.database,
            scope: { connection in
                ReadSettings(
                    settings: DatabaseSettingsQueries(connection: connection)
                )
            }
        )
        return .init(query: query)
    }

    func makeListPublicMenus() -> ListPublicMenus {
        let query = DatabaseQueryExecutor(
            database: infrastructure.database,
            scope: { connection in
                ReadPublicMenu(
                    menu: DatabaseMenuQueries(connection: connection),
                    menuItem: DatabaseMenuItemQueries(connection: connection)
                )
            }
        )
        return .init(
            authorizer: authorizer,
            query: query
        )
    }

    func makeAddMetadata() -> AddMetadata {
        let transaction = DatabaseTransactionExecutor(
            database: infrastructure.database,
            scope: { connection in
                WriteMetadata(
                    metadata: DatabaseMetadataRepository(connection: connection)
                )
            }
        )
        return .init(
            authorizer: authorizer,
            transaction: transaction,
            idGenerator: infrastructure.idGenerator
        )
    }

    func makeGetMetadata() -> GetMetadata {
        let query = DatabaseQueryExecutor(
            database: infrastructure.database,
            scope: { connection in
                ReadMetadata(
                    metadata: DatabaseMetadataQueries(connection: connection)
                )
            }
        )
        return .init(
            authorizer: authorizer,
            query: query
        )
    }

    func makeEditMetadata() -> EditMetadata {
        let transaction = DatabaseTransactionExecutor(
            database: infrastructure.database,
            scope: { connection in
                WriteMetadata(
                    metadata: DatabaseMetadataRepository(connection: connection)
                )
            }
        )
        return .init(
            authorizer: authorizer,
            transaction: transaction
        )
    }

    func makeListMetadata() -> ListMetadata {
        let query = DatabaseQueryExecutor(
            database: infrastructure.database,
            scope: { connection in
                ReadMetadata(
                    metadata: DatabaseMetadataQueries(connection: connection)
                )
            }
        )
        return .init(
            authorizer: authorizer,
            query: query
        )
    }

    func makeResolveWebRoute() -> ResolveWebRoute {
        let query = DatabaseQueryExecutor(
            database: infrastructure.database,
            scope: { connection in
                ReadMetadata(
                    metadata: DatabaseMetadataQueries(connection: connection)
                )
            }
        )
        return .init(query: query)
    }

    func makeRemoveMetadata() -> RemoveMetadata {
        let transaction = DatabaseTransactionExecutor(
            database: infrastructure.database,
            scope: { connection in
                WriteMetadata(
                    metadata: DatabaseMetadataRepository(connection: connection)
                )
            }
        )
        return .init(
            authorizer: authorizer,
            transaction: transaction
        )
    }

    func makeGetPublicPageByID() -> GetPublicPageByID {
        let query = DatabaseQueryExecutor(
            database: infrastructure.database,
            scope: { connection in
                ReadPageMetadata(
                    page: DatabasePageQueries(connection: connection),
                    metadata: DatabaseMetadataQueries(connection: connection)
                )
            }
        )
        return .init(query: query)
    }

    func makeAddPage() -> AddPage {
        let transaction = DatabaseTransactionExecutor(
            database: infrastructure.database,
            scope: { connection in
                WritePageMetadata(
                    page: DatabasePageRepository(connection: connection),
                    metadata: DatabaseMetadataRepository(
                        connection: connection
                    ),
                    settings: DatabaseSettingsRepository(connection: connection),
                    variable: DatabaseVariableQueries(connection: connection)
                )
            }
        )
        return .init(
            authorizer: authorizer,
            transaction: transaction,
            idGenerator: infrastructure.idGenerator
        )
    }

    func makeGetPage() -> GetPage {
        let query = DatabaseQueryExecutor(
            database: infrastructure.database,
            scope: { connection in
                ReadPageMetadata(
                    page: DatabasePageQueries(connection: connection),
                    metadata: DatabaseMetadataQueries(connection: connection)
                )
            }
        )
        return .init(
            authorizer: authorizer,
            query: query
        )
    }

    func makeEditPage() -> EditPage {
        let transaction = DatabaseTransactionExecutor(
            database: infrastructure.database,
            scope: { connection in
                WritePageMetadata(
                    page: DatabasePageRepository(connection: connection),
                    metadata: DatabaseMetadataRepository(
                        connection: connection
                    ),
                    settings: DatabaseSettingsRepository(connection: connection),
                    variable: DatabaseVariableQueries(connection: connection)
                )
            }
        )
        return .init(
            authorizer: authorizer,
            transaction: transaction
        )
    }

    func makeListPages() -> ListPages {
        let query = DatabaseQueryExecutor(
            database: infrastructure.database,
            scope: { connection in
                ReadPageMetadata(
                    page: DatabasePageQueries(connection: connection),
                    metadata: DatabaseMetadataQueries(connection: connection)
                )
            }
        )
        return .init(
            authorizer: authorizer,
            query: query
        )
    }

    func makeRemovePage() -> RemovePage {
        let transaction = DatabaseTransactionExecutor(
            database: infrastructure.database,
            scope: { connection in
                WritePageMetadata(
                    page: DatabasePageRepository(connection: connection),
                    metadata: DatabaseMetadataRepository(
                        connection: connection
                    ),
                    settings: DatabaseSettingsRepository(connection: connection),
                    variable: DatabaseVariableQueries(connection: connection)
                )
            }
        )
        return .init(
            authorizer: authorizer,
            transaction: transaction
        )
    }

    func makeAddMenu() -> AddMenu {
        let transaction = DatabaseTransactionExecutor(
            database: infrastructure.database,
            scope: { connection in
                WriteMenu(
                    menu: DatabaseMenuRepository(connection: connection)
                )
            }
        )
        return .init(
            authorizer: authorizer,
            transaction: transaction,
            idGenerator: infrastructure.idGenerator
        )
    }

    func makeGetMenu() -> GetMenu {
        let query = DatabaseQueryExecutor(
            database: infrastructure.database,
            scope: { connection in
                ReadMenu(
                    menu: DatabaseMenuQueries(connection: connection)
                )
            }
        )
        return .init(
            authorizer: authorizer,
            query: query
        )
    }

    func makeEditMenu() -> EditMenu {
        let transaction = DatabaseTransactionExecutor(
            database: infrastructure.database,
            scope: { connection in
                WriteMenu(
                    menu: DatabaseMenuRepository(connection: connection)
                )
            }
        )
        return .init(
            authorizer: authorizer,
            transaction: transaction
        )
    }

    func makeListMenus() -> ListMenus {
        let query = DatabaseQueryExecutor(
            database: infrastructure.database,
            scope: { connection in
                ReadMenu(
                    menu: DatabaseMenuQueries(connection: connection)
                )
            }
        )
        return .init(
            authorizer: authorizer,
            query: query
        )
    }

    func makeRemoveMenu() -> RemoveMenu {
        let transaction = DatabaseTransactionExecutor(
            database: infrastructure.database,
            scope: { connection in
                WriteMenu(
                    menu: DatabaseMenuRepository(connection: connection)
                )
            }
        )
        return .init(
            authorizer: authorizer,
            transaction: transaction
        )
    }

    func makeAddMenuItem() -> AddMenuItem {
        let transaction = DatabaseTransactionExecutor(
            database: infrastructure.database,
            scope: { connection in
                WriteMenuItem(
                    menuItem: DatabaseMenuItemRepository(connection: connection)
                )
            }
        )
        return .init(
            authorizer: authorizer,
            transaction: transaction,
            idGenerator: infrastructure.idGenerator
        )
    }

    func makeGetMenuItem() -> GetMenuItem {
        let query = DatabaseQueryExecutor(
            database: infrastructure.database,
            scope: { connection in
                ReadMenuItem(
                    menuItem: DatabaseMenuItemQueries(connection: connection)
                )
            }
        )
        return .init(
            authorizer: authorizer,
            query: query
        )
    }

    func makeEditMenuItem() -> EditMenuItem {
        let transaction = DatabaseTransactionExecutor(
            database: infrastructure.database,
            scope: { connection in
                WriteMenuItem(
                    menuItem: DatabaseMenuItemRepository(connection: connection)
                )
            }
        )
        return .init(
            authorizer: authorizer,
            transaction: transaction
        )
    }

    func makeListMenuItems() -> ListMenuItems {
        let query = DatabaseQueryExecutor(
            database: infrastructure.database,
            scope: { connection in
                ReadMenuItem(
                    menuItem: DatabaseMenuItemQueries(connection: connection)
                )
            }
        )
        return .init(
            authorizer: authorizer,
            query: query
        )
    }

    func makeRemoveMenuItem() -> RemoveMenuItem {
        let transaction = DatabaseTransactionExecutor(
            database: infrastructure.database,
            scope: { connection in
                WriteMenuItem(
                    menuItem: DatabaseMenuItemRepository(connection: connection)
                )
            }
        )
        return .init(
            authorizer: authorizer,
            transaction: transaction
        )
    }

    func makeGetSettings() -> GetSettings {
        let query = DatabaseQueryExecutor(
            database: infrastructure.database,
            scope: { connection in
                ReadSettings(
                    settings: DatabaseSettingsQueries(connection: connection)
                )
            }
        )
        return .init(
            authorizer: authorizer,
            query: query
        )
    }

    func makeEditSettings() -> EditSettings {
        let transaction = DatabaseTransactionExecutor(
            database: infrastructure.database,
            scope: { connection in
                WriteSettings(
                    settings: DatabaseSettingsRepository(connection: connection)
                )
            }
        )
        return .init(
            authorizer: authorizer,
            transaction: transaction
        )
    }
}
