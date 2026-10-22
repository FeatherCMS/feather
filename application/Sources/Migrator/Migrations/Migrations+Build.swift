public import FeatherModuleKit
import AccountInfrastructure
import AnalyticsInfrastructure
import AuthInfrastructure
import AuthModule
import BlogInfrastructure
import BlogModule
import ContactInfrastructure
public import FeatherDatabase
public import FeatherDBAL
public import FeatherDomain
public import FeatherInfrastructure
import FeatherDBALPostgres
import MediaInfrastructure
import NewsletterInfrastructure
import NewsInfrastructure
import RedirectInfrastructure
import SystemApplication
import SystemInfrastructure
import SystemModule
import UserModule
import UserInfrastructure
import WebInfrastructure
import WebModule

public func buildMigrations(
    connection: any DatabaseConnection,
    platform: any DatabasePlatform,
    events: any EventPublisher,
    idGenerator: any IDGenerator
) -> [any Migration] {
    let context = DatabaseTransactionContext(
        platform: platform,
        connection: connection,
        idGenerator: idGenerator
    )
    return [
        // Tables
        SystemInfrastructure.TableMigration(
            connection: connection,
            platform: platform
        ),
        AnalyticsInfrastructure.TableMigration(connection: connection),
        MediaInfrastructure.TableMigration(connection: connection),
        WebInfrastructure.TableMigration(
            connection: connection,
            platform: platform
        ),
        RedirectInfrastructure.TableMigration(connection: connection),
        BlogInfrastructure.TableMigration(
            connection: connection,
            platform: platform
        ),
        NewsInfrastructure.TableMigration(connection: connection),
        UserInfrastructure.TableMigration(
            connection: connection,
            platform: platform
        ),
        AccountInfrastructure.TableMigration(connection: connection),
        AuthInfrastructure.TableMigration(
            connection: connection,
            platform: platform
        ),
        ContactInfrastructure.TableMigration(
            connection: connection,
            platform: platform
        ),
        NewsletterInfrastructure.TableMigration(connection: connection),

        // Media folder structure
        WebInfrastructure.MediaFolderMigration(
            platform: platform,
            connection: connection,
            idGenerator: idGenerator
        ),
        BlogInfrastructure.MediaFolderMigration(
            platform: platform,
            connection: connection,
            idGenerator: idGenerator
        ),
        NewsInfrastructure.MediaFolderMigration(
            platform: platform,
            connection: connection,
            idGenerator: idGenerator
        ),

        // Seed data
        SystemInfrastructure.TableSeedMigration(
            context: context,
            platform: platform,
            events: events
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
    SystemModule.Event.Handlers.register(in: &events)
    FeatherVariableSeedEventHandlers.register(in: &events)
    AuthModule.Event.Handlers.register(in: &events)
    UserModule.Event.Handlers.register(in: &events)
    AccountModule.Event.Handlers.register(in: &events)
    AnalyticsInfrastructure.EventHandlers.register(in: &events)
    RedirectInfrastructure.EventHandlers.register(in: &events)
    MediaInfrastructure.EventHandlers.register(in: &events)
    ContactInfrastructure.EventHandlers.register(in: &events)
    NewsletterInfrastructure.EventHandlers.register(in: &events)
    BlogModule.Event.Handlers.register(in: &events)
    NewsInfrastructure.EventHandlers.register(in: &events)
    WebModule.Event.Handlers.register(
        in: &events,
        publicBaseURL: webPublicBaseURL
    )
    return events
}
