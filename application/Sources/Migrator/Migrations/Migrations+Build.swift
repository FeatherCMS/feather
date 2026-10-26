public import FeatherModuleKit
import AccountInfrastructure
import AccountModule
import AnalyticsInfrastructure
import AnalyticsModule
import AuthInfrastructure
import AuthModule
import BlogInfrastructure
import BlogModule
import ContactInfrastructure
import ContactModule
public import FeatherDatabase
public import FeatherDBAL
public import FeatherDomain
public import FeatherInfrastructure
import FeatherDBALPostgres
import MediaInfrastructure
import MediaModule
import NewsletterInfrastructure
import NewsletterModule
import NewsInfrastructure
import NewsModule
import RedirectInfrastructure
import RedirectModule
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
        AnalyticsInfrastructure.TableMigration(
            connection: connection,
            platform: platform
        ),
        MediaInfrastructure.TableMigration(
            connection: connection,
            platform: platform
        ),
        WebInfrastructure.TableMigration(
            connection: connection,
            platform: platform
        ),
        RedirectInfrastructure.TableMigration(
            connection: connection,
            platform: platform
        ),
        BlogInfrastructure.TableMigration(
            connection: connection,
            platform: platform
        ),
        NewsInfrastructure.TableMigration(
            connection: connection,
            platform: platform
        ),
        UserInfrastructure.TableMigration(
            connection: connection,
            platform: platform
        ),
        AccountInfrastructure.TableMigration(
            connection: connection,
            platform: platform
        ),
        AuthInfrastructure.TableMigration(
            connection: connection,
            platform: platform
        ),
        ContactInfrastructure.TableMigration(
            connection: connection,
            platform: platform
        ),
        NewsletterInfrastructure.TableMigration(
            connection: connection,
            platform: platform
        ),

        // Media folder structure
        WebInfrastructure.MediaFolderSeedMigration(
            platform: platform,
            connection: connection,
            idGenerator: idGenerator
        ),
        BlogInfrastructure.MediaFolderSeedMigration(
            platform: platform,
            connection: connection,
            idGenerator: idGenerator
        ),
        NewsInfrastructure.MediaFolderSeedMigration(
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
    AnalyticsModule.Event.Handlers.register(in: &events)
    RedirectModule.Event.Handlers.register(in: &events)
    MediaModule.Event.Handlers.register(in: &events)
    ContactModule.Event.Handlers.register(in: &events)
    NewsletterModule.Event.Handlers.register(in: &events)
    BlogModule.Event.Handlers.register(in: &events)
    NewsModule.Event.Handlers.register(in: &events)
    WebModule.Event.Handlers.register(
        in: &events,
        publicBaseURL: webPublicBaseURL
    )
    return events
}
