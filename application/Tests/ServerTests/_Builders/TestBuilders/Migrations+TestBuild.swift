import FeatherDatabase
import FeatherDBALPostgres
import FeatherModuleKit
import FeatherDomain
import FeatherInfrastructure
import AccountInfrastructure
import AccountModule
import AnalyticsInfrastructure
import AnalyticsModule
import SystemApplication
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
import MediaModule
import NewsInfrastructure
import NewsModule
import NewsletterInfrastructure
import NewsletterModule
import RedirectInfrastructure
import RedirectModule
import WebInfrastructure
import WebModule

func buildTestMigrations(
    connection: any DatabaseConnection,
    idGenerator: any IDGenerator
) -> [any Migration] {
    var events = EventRegistry()
    SystemModule.Event.Handlers.register(in: &events)
    events.register(event: SystemModule.Variable.Event.Seed.self) { _ in
        [
            .init(
                key: "system-settings-mail-from-address",
                value: "info@binarybirds.com",
                name: "System mail from address",
                notes: "Sender address for system-generated emails."
            ),
            .init(
                key: "system-settings-mail-from-name",
                value: "Binary Birds",
                name: "System mail from name",
                notes:
                    "Optional sender display name for system-generated emails."
            ),
            .init(
                key: "auth.magic_link.email.subject",
                value: "Application - Sign In Link",
                name: "Magic link email subject",
                notes: "Subject line for magic link sign-in emails."
            ),
            .init(
                key: "account.invitation.email.subject",
                value: "Application - Invitation",
                name: "Invitation email subject",
                notes: "Subject line for account invitation emails."
            ),
        ]
    }
    AuthModule.Event.Handlers.register(in: &events)
    UserModule.Event.Handlers.register(in: &events)
    AccountModule.Event.Handlers.register(in: &events)
    AnalyticsModule.Event.Handlers.register(in: &events)
    RedirectModule.Event.Handlers.register(in: &events)
    MediaModule.Event.Handlers.register(in: &events)
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
        RedirectInfrastructure.TableMigration(
            connection: connection,
            platform: PostgresDatabasePlatform()
        ),
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
        AccountInfrastructure.TableMigration(
            connection: connection,
            platform: PostgresDatabasePlatform()
        ),
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
