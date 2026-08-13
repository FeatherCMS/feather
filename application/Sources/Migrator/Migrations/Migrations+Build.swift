import FeatherContracts
import AccountInfrastructure
import AnalyticsInfrastructure
import AuthInfrastructure
import BlogInfrastructure
import ContactInfrastructure
import FeatherDatabase
import FeatherApplication
import FeatherDomain
import FeatherInfrastructure
import MediaInfrastructure
import NewsletterInfrastructure
import NewsInfrastructure
import RedirectInfrastructure
import SystemInfrastructure
import UserInfrastructure
import WebInfrastructure

public func buildMigrations(
    connection: any DatabaseConnection,
    events: any EventPublisher,
    idGenerator: any IDGenerator
) -> [Migration] {
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
        SystemInfrastructure.TableSeedMigration(
            connection: connection,
            events: events,
            idGenerator: idGenerator
        ),
        UserInfrastructure.TableSeedMigration(
            connection: connection,
            events: events,
            idGenerator: idGenerator
        ),
        AuthInfrastructure.TableSeedMigration(
            connection: connection,
            idGenerator: idGenerator
        ),
        MediaInfrastructure.TableSeedMigration(
            connection: connection
        ),
        WebInfrastructure.TableSeedMigration(
            connection: connection,
            idGenerator: idGenerator,
            events: events
        ),
        AnalyticsInfrastructure.TableSeedMigration(
            connection: connection
        ),
        ContactInfrastructure.TableSeedMigration(
            connection: connection,
            idGenerator: idGenerator
        ),
        BlogInfrastructure.TableSeedMigration(
            connection: connection,
            idGenerator: idGenerator
        ),
        NewsInfrastructure.TableSeedMigration(
            connection: connection,
            idGenerator: idGenerator
        ),
    ]
}

public func buildMigrationEventPublisher() -> any EventPublisher {
    var events = EventRegistry()
    SystemInfrastructure.EventHandlers.register(in: &events)
    AuthInfrastructure.EventHandlers.register(in: &events)
    UserInfrastructure.EventHandlers.register(in: &events)
    AccountInfrastructure.EventHandlers.register(in: &events)
    AnalyticsInfrastructure.EventHandlers.register(in: &events)
    RedirectInfrastructure.EventHandlers.register(in: &events)
    MediaInfrastructure.EventHandlers.register(in: &events)
    ContactInfrastructure.EventHandlers.register(in: &events)
    NewsletterInfrastructure.EventHandlers.register(in: &events)
    BlogInfrastructure.EventHandlers.register(in: &events)
    NewsInfrastructure.EventHandlers.register(in: &events)
    WebInfrastructure.EventHandlers.register(in: &events)
    return events
}
