import FeatherDatabase
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
    UserSystemEventHandlers.register(in: &events)
    AccountInfrastructure.EventHandlers.register(in: &events)
    AnalyticsSystemEventHandlers.register(in: &events)
    RedirectSystemEventHandlers.register(in: &events)
    MediaSystemEventHandlers.register(in: &events)
    ContactInfrastructure.EventHandlers.register(in: &events)
    EventHandlers.register(in: &events)
    BlogInfrastructure.EventHandlers.register(in: &events)
    NewsSystemEventHandlers.register(in: &events)
    WebSystemEventHandlers.register(in: &events)

    [
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
            events: events
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
        NewsletterInfrastructure.TableSeedMigration(connection: connection),
    ]
}
