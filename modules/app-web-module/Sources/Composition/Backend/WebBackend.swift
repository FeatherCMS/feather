import FeatherApplication
import FeatherContracts
import FeatherDatabase
import FeatherDomain
import FeatherInfrastructure
import Foundation
import SystemInfrastructure
import WebAdminAPI
import WebAppAPI
import WebApplication
import WebInfrastructure

public struct WebBackend: Sendable, WebAdminAPI.APIProtocol, WebAppAPI
        .APIProtocol
{

    private let database: any DatabaseClient
    private let idGenerator: any IDGenerator
    public let authorizer: any Authorizer

    public init(
        database: any DatabaseClient,
        idGenerator: any IDGenerator,
        authorizer: any Authorizer
    ) {
        self.database = database
        self.idGenerator = idGenerator
        self.authorizer = authorizer
    }
}

extension WebBackend {

    func makeGetPublicSettings() -> GetPublicSettings {
        let query = DatabaseQueryExecutor(
            database: database,
            scope: { context in
                WriteSettings(
                    settings: SettingsDatabaseRepository(context: context)
                )
            }
        )
        return .init(query: query)
    }

    func makeListPublicMenus() -> ListPublicMenus {
        let query = DatabaseQueryExecutor(
            database: database,
            scope: { context in
                ReadPublicMenu(
                    menu: MenuDatabaseQueries(
                        context: context
                    ),
                    menuItem: MenuItemDatabaseQueries(
                        context: context
                    )
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
            database: database,
            idGenerator: idGenerator,
            scope: { context in
                WriteMetadata(
                    metadata: MetadataDatabaseRepository(context: context)
                )
            }
        )
        return .init(
            authorizer: authorizer,
            transaction: transaction
        )
    }

    func makeGetMetadata() -> GetMetadata {
        let query = DatabaseQueryExecutor(
            database: database,
            scope: { context in
                ReadMetadata(
                    metadata: MetadataDatabaseQueries(
                        context: context
                    )
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
            database: database,
            idGenerator: idGenerator,
            scope: { context in
                WriteMetadata(
                    metadata: MetadataDatabaseRepository(context: context)
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
            database: database,
            scope: { context in
                ReadMetadata(
                    metadata: MetadataDatabaseQueries(
                        context: context
                    )
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
            database: database,
            scope: { context in
                ReadMetadata(
                    metadata: MetadataDatabaseQueries(
                        context: context
                    )
                )
            }
        )
        return .init(query: query)
    }

    func makeRemoveMetadata() -> RemoveMetadata {
        let transaction = DatabaseTransactionExecutor(
            database: database,
            idGenerator: idGenerator,
            scope: { context in
                WriteMetadata(
                    metadata: MetadataDatabaseRepository(context: context)
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
            database: database,
            scope: { context in
                ReadPageMetadata(
                    page: PageDatabaseQueries(
                        context: context,
                        metadata: MetadataDatabaseQueries(
                            context: context
                        )
                    ),
                    metadata: MetadataDatabaseQueries(
                        context: context
                    )
                )
            }
        )
        return .init(query: query)
    }

    func makeAddPage() -> AddPage {
        let transaction = DatabaseTransactionExecutor(
            database: database,
            idGenerator: idGenerator,
            scope: { context in
                WritePageMetadata(
                    page: PageDatabaseRepository(context: context),
                    metadata: MetadataDatabaseRepository(context: context),
                    settings: SettingsDatabaseRepository(context: context),
                    variable: VariableDatabaseQueries(
                        context: .init(connection: context.connection)
                    )
                )
            }
        )
        return .init(
            authorizer: authorizer,
            transaction: transaction
        )
    }

    func makeGetPage() -> GetPage {
        let query = DatabaseQueryExecutor(
            database: database,
            scope: { context in
                ReadPageMetadata(
                    page: PageDatabaseQueries(
                        context: context,
                        metadata: MetadataDatabaseQueries(
                            context: context
                        )
                    ),
                    metadata: MetadataDatabaseQueries(
                        context: context
                    )
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
            database: database,
            idGenerator: idGenerator,
            scope: { context in
                WritePageMetadata(
                    page: PageDatabaseRepository(context: context),
                    metadata: MetadataDatabaseRepository(context: context),
                    settings: SettingsDatabaseRepository(context: context),
                    variable: VariableDatabaseQueries(
                        context: .init(connection: context.connection)
                    )
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
            database: database,
            scope: { context in
                ReadPageMetadata(
                    page: PageDatabaseQueries(
                        context: context,
                        metadata: MetadataDatabaseQueries(
                            context: context
                        )
                    ),
                    metadata: MetadataDatabaseQueries(
                        context: context
                    )
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
            database: database,
            idGenerator: idGenerator,
            scope: { context in
                WritePageMetadata(
                    page: PageDatabaseRepository(context: context),
                    metadata: MetadataDatabaseRepository(context: context),
                    settings: SettingsDatabaseRepository(context: context),
                    variable: VariableDatabaseQueries(
                        context: .init(connection: context.connection)
                    )
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
            database: database,
            idGenerator: idGenerator,
            scope: { context in
                WriteMenu(
                    menu: MenuDatabaseRepository(context: context)
                )
            }
        )
        return .init(
            authorizer: authorizer,
            transaction: transaction
        )
    }

    func makeGetMenu() -> GetMenu {
        let query = DatabaseQueryExecutor(
            database: database,
            scope: { context in
                ReadMenu(
                    menu: MenuDatabaseQueries(
                        context: context
                    )
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
            database: database,
            idGenerator: idGenerator,
            scope: { context in
                WriteMenu(
                    menu: MenuDatabaseRepository(context: context)
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
            database: database,
            scope: { context in
                ReadMenu(
                    menu: MenuDatabaseQueries(
                        context: context
                    )
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
            database: database,
            idGenerator: idGenerator,
            scope: { context in
                WriteMenu(
                    menu: MenuDatabaseRepository(context: context)
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
            database: database,
            idGenerator: idGenerator,
            scope: { context in
                WriteMenuItem(
                    menuItem: MenuItemDatabaseRepository(context: context)
                )
            }
        )
        return .init(
            authorizer: authorizer,
            transaction: transaction
        )
    }

    func makeGetMenuItem() -> GetMenuItem {
        let query = DatabaseQueryExecutor(
            database: database,
            scope: { context in
                ReadMenuItem(
                    menuItem: MenuItemDatabaseQueries(
                        context: context
                    )
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
            database: database,
            idGenerator: idGenerator,
            scope: { context in
                WriteMenuItem(
                    menuItem: MenuItemDatabaseRepository(context: context)
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
            database: database,
            scope: { context in
                ReadMenuItem(
                    menuItem: MenuItemDatabaseQueries(
                        context: context
                    )
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
            database: database,
            idGenerator: idGenerator,
            scope: { context in
                WriteMenuItem(
                    menuItem: MenuItemDatabaseRepository(context: context)
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
            database: database,
            scope: { context in
                WriteSettings(
                    settings: SettingsDatabaseRepository(context: context)
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
            database: database,
            idGenerator: idGenerator,
            scope: { context in
                WriteSettings(
                    settings: SettingsDatabaseRepository(context: context)
                )
            }
        )
        return .init(
            authorizer: authorizer,
            transaction: transaction
        )
    }
}
