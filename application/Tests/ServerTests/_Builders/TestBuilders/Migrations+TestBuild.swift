import FeatherDatabase
import FeatherContracts
import FeatherDomain
import FeatherInfrastructure
import AccountInfrastructure
import AnalyticsInfrastructure
import SystemInfrastructure
import UserInfrastructure
import AuthInfrastructure
import BlogInfrastructure
import ContactInfrastructure
import MediaInfrastructure
import NewsInfrastructure
import NewsletterInfrastructure
import RedirectInfrastructure
import WebInfrastructure

public func buildTestMigrations(
    connection: any DatabaseConnection,
    idGenerator: any IDGenerator
) -> [Migration] {
    var events = EventRegistry()
    SystemInfrastructure.EventHandlers.register(in: &events)
    AuthInfrastructure.EventHandlers.register(in: &events)
    UserInfrastructure.EventHandlers.register(in: &events)
    AccountInfrastructure.EventHandlers.register(in: &events)
    AnalyticsInfrastructure.EventHandlers.register(in: &events)
    RedirectInfrastructure.EventHandlers.register(in: &events)
    MediaInfrastructure.EventHandlers.register(in: &events)
    ContactInfrastructure.EventHandlers.register(in: &events)
    BlogInfrastructure.EventHandlers.register(in: &events)
    NewsInfrastructure.EventHandlers.register(in: &events)
    WebInfrastructure.EventHandlers.register(in: &events)

    return [
        // Tables
        SystemInfrastructure.TableMigration(connection: connection),
        AnalyticsInfrastructure.TableMigration(connection: connection),
        WebInfrastructure.TableMigration(connection: connection),
        RedirectInfrastructure.TableMigration(connection: connection),
        BlogInfrastructure.TableMigration(connection: connection),
        NewsInfrastructure.TableMigration(connection: connection),
        UserInfrastructure.TableMigration(connection: connection),
        AccountInfrastructure.TableMigration(connection: connection),
        AuthInfrastructure.TableMigration(connection: connection),
        MediaInfrastructure.TableMigration(connection: connection),
        ContactInfrastructure.TableMigration(connection: connection),
        NewsletterInfrastructure.TableMigration(connection: connection),
        // Seed data
        UserInfrastructure.TableSeedMigration(
            connection: connection,
            events: events,
            idGenerator: idGenerator
        ),
        SystemInfrastructure.TableSeedMigration(
            connection: connection,
            events: events,
            idGenerator: idGenerator
        ),
        AnalyticsInfrastructure.TableSeedMigration(connection: connection),
        WebInfrastructure.TableSeedMigration(
            connection: connection,
            idGenerator: idGenerator,
            events: events
        ),
        BlogInfrastructure.TableSeedMigration(
            connection: connection,
            idGenerator: idGenerator
        ),

        NewsInfrastructure.TableSeedMigration(
            connection: connection,
            idGenerator: idGenerator
        ),
        AuthInfrastructure.TableSeedMigration(
            connection: connection,
            idGenerator: idGenerator
        ),
        MediaInfrastructure.TableSeedMigration(connection: connection),
        ContactInfrastructure.TableSeedMigration(
            connection: connection,
            idGenerator: idGenerator
        ),
    ]
}
