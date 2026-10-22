import FeatherDatabase
import FeatherDBALPostgres
import FeatherModuleKit
import FeatherDomain
import FeatherInfrastructure
import AccountInfrastructure
import AnalyticsInfrastructure
import SystemInfrastructure
import SystemModule
import UserModule
import UserInfrastructure
import AuthInfrastructure
import AuthModule
import BlogInfrastructure
import BlogModule
import ContactInfrastructure
import MediaInfrastructure
import NewsInfrastructure
import NewsletterInfrastructure
import RedirectInfrastructure
import WebInfrastructure
import WebModule

public func buildTestMigrations(
    connection: any DatabaseConnection,
    idGenerator: any IDGenerator
) -> [Migration] {
    var events = EventRegistry()
    SystemModule.Event.Handlers.register(in: &events)
    AuthModule.Event.Handlers.register(in: &events)
    UserModule.Event.Handlers.register(in: &events)
    AccountModule.Event.Handlers.register(in: &events)
    AnalyticsInfrastructure.EventHandlers.register(in: &events)
    RedirectInfrastructure.EventHandlers.register(in: &events)
    MediaInfrastructure.EventHandlers.register(in: &events)
    ContactInfrastructure.EventHandlers.register(in: &events)
    BlogModule.Event.Handlers.register(in: &events)
    NewsInfrastructure.EventHandlers.register(in: &events)
    WebModule.Event.Handlers.register(
        in: &events,
        publicBaseURL: "http://localhost:3456"
    )

    let context = DatabaseTransactionContext(
        platform: PostgresDatabasePlatform(),
        connection: connection,
        idGenerator: idGenerator
    )
    return [
        // Tables
        SystemInfrastructure.TableMigration(connection: connection),
        AnalyticsInfrastructure.TableMigration(connection: connection),
        MediaInfrastructure.TableMigration(connection: connection),
        WebInfrastructure.TableMigration(
            connection: connection,
            platform: PostgresDatabasePlatform()
        ),
        RedirectInfrastructure.TableMigration(connection: connection),
        BlogInfrastructure.TableMigration(
            connection: connection,
            platform: PostgresDatabasePlatform()
        ),
        NewsInfrastructure.TableMigration(connection: connection),
        UserInfrastructure.TableMigration(
            connection: connection,
            platform: PostgresDatabasePlatform()
        ),
        AccountInfrastructure.TableMigration(connection: connection),
        AuthInfrastructure.TableMigration(
            connection: connection,
            platform: PostgresDatabasePlatform()
        ),
        ContactInfrastructure.TableMigration(
            connection: connection,
            platform: PostgresDatabasePlatform()
        ),
        NewsletterInfrastructure.TableMigration(connection: connection),
        // Seed data
        UserInfrastructure.TableSeedMigration(
            context: context,
            events: events
        ),
        SystemInfrastructure.TableSeedMigration(
            context: context,
            platform: PostgresDatabasePlatform(),
            events: events
        ),
        AnalyticsInfrastructure.TableSeedMigration(context: context),
        WebInfrastructure.TableSeedMigration(
            context: context,
            events: events
        ),
        BlogInfrastructure.TableSeedMigration(
            context: context
        ),

        NewsInfrastructure.TableSeedMigration(
            context: context
        ),
        AuthInfrastructure.TableSeedMigration(
            context: context,
            events: events
        ),
        AccountInfrastructure.TableSeedMigration(
            context: context,
            events: events
        ),
        MediaInfrastructure.TableSeedMigration(context: context),
        ContactInfrastructure.TableSeedMigration(context: context),
    ]
}
