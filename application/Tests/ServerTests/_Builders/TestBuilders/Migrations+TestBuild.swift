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
    WebInfrastructure.EventHandlers.register(
        in: &events,
        publicBaseURL: "http://localhost:3456"
    )

    let context = DatabaseTransactionContext(
        connection: connection,
        idGenerator: idGenerator
    )
    return [
        // Tables
        SystemInfrastructure.TableMigration(connection: connection),
        AnalyticsInfrastructure.TableMigration(connection: connection),
        MediaInfrastructure.TableMigration(connection: connection),
        WebInfrastructure.TableMigration(connection: connection),
        RedirectInfrastructure.TableMigration(connection: connection),
        BlogInfrastructure.TableMigration(connection: connection),
        NewsInfrastructure.TableMigration(connection: connection),
        UserInfrastructure.TableMigration(connection: connection),
        AccountInfrastructure.TableMigration(connection: connection),
        AuthInfrastructure.TableMigration(connection: connection),
        ContactInfrastructure.TableMigration(connection: connection),
        NewsletterInfrastructure.TableMigration(connection: connection),
        // Seed data
        UserInfrastructure.TableSeedMigration(
            context: context,
            events: events
        ),
        SystemInfrastructure.TableSeedMigration(
            context: context,
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
