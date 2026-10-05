public import FeatherContracts
import AccountInfrastructure
import AnalyticsInfrastructure
import AuthInfrastructure
import BlogInfrastructure
import ContactInfrastructure
public import FeatherDatabase
public import FeatherDomain
public import FeatherInfrastructure
import MediaInfrastructure
import NewsletterInfrastructure
import NewsInfrastructure
import RedirectInfrastructure
import SystemApplication
import SystemInfrastructure
import UserInfrastructure
import WebInfrastructure

public func buildMigrations(
    connection: any DatabaseConnection,
    events: any EventPublisher,
    idGenerator: any IDGenerator
) -> [any Migration] {
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

        // Media folder structure
        WebInfrastructure.MediaFolderMigration(
            connection: connection,
            idGenerator: idGenerator
        ),
        BlogInfrastructure.MediaFolderMigration(
            connection: connection,
            idGenerator: idGenerator
        ),
        NewsInfrastructure.MediaFolderMigration(
            connection: connection,
            idGenerator: idGenerator
        ),

        // Seed data
        SystemInfrastructure.TableSeedMigration(
            context: context,
            events: events
        ),
        SystemInfrastructure.MailFromVariableMigration(
            connection: connection,
            events: events,
            idGenerator: idGenerator
        ),
        UserInfrastructure.TableSeedMigration(
            context: context,
            events: events
        ),
        AuthInfrastructure.TableSeedMigration(
            context: context,
            events: events
        ),
        AccountInfrastructure.TableSeedMigration(
            context: context,
            events: events
        ),
        MediaInfrastructure.TableSeedMigration(
            context: context
        ),
        WebInfrastructure.TableSeedMigration(
            context: context,
            events: events
        ),
        AnalyticsInfrastructure.TableSeedMigration(context: context),
        ContactInfrastructure.TableSeedMigration(context: context),
        BlogInfrastructure.TableSeedMigration(context: context),
        NewsInfrastructure.TableSeedMigration(context: context),
    ]
}

public func buildMigrationEventPublisher(
    webPublicBaseURL: String
) -> any EventPublisher {
    var events = EventRegistry()
    SystemInfrastructure.EventHandlers.register(in: &events)
    FeatherMailFromAddressEventHandlers.register(in: &events)
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
    WebInfrastructure.EventHandlers.register(
        in: &events,
        publicBaseURL: webPublicBaseURL
    )
    return events
}
