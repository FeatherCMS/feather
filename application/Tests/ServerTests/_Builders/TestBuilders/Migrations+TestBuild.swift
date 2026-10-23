import FeatherDatabase
import FeatherDBALPostgres
import FeatherModuleKit
import FeatherDomain
import FeatherInfrastructure
import AccountInfrastructure
import AccountModule
import AnalyticsInfrastructure
import AnalyticsModule
import SystemInfrastructure
import SystemModule
import UserModule
import UserInfrastructure
import AuthInfrastructure
import AuthModule
import BlogInfrastructure
import BlogModule
import ContactInfrastructure
import ContactModule
import MediaInfrastructure
import NewsInfrastructure
import NewsModule
import NewsletterInfrastructure
import NewsletterModule
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
    AnalyticsModule.Event.Handlers.register(in: &events)
    RedirectInfrastructure.EventHandlers.register(in: &events)
    MediaInfrastructure.EventHandlers.register(in: &events)
    ContactModule.Event.Handlers.register(in: &events)
    BlogModule.Event.Handlers.register(in: &events)
    NewsModule.Event.Handlers.register(in: &events)
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
        SystemInfrastructure.TableMigration(
            connection: connection,
            platform: PostgresDatabasePlatform()
        ),
        AnalyticsInfrastructure.TableMigration(
            connection: connection,
            platform: PostgresDatabasePlatform()
        ),
        MediaInfrastructure.TableMigration(
            connection: connection,
            platform: PostgresDatabasePlatform()
        ),
        WebInfrastructure.TableMigration(
            connection: connection,
            platform: PostgresDatabasePlatform()
        ),
        RedirectInfrastructure.TableMigration(connection: connection),
        BlogInfrastructure.TableMigration(
            connection: connection,
            platform: PostgresDatabasePlatform()
        ),
        NewsInfrastructure.TableMigration(
            connection: connection,
            platform: PostgresDatabasePlatform()
        ),
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
        NewsletterInfrastructure.TableMigration(
            connection: connection,
            platform: PostgresDatabasePlatform()
        ),
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
