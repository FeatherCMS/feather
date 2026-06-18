import FeatherDatabase
import Infrastructure
import SystemInfrastructure
import AnalyticsInfrastructure
import RedirectInfrastructure
import WebInfrastructure
import BlogInfrastructure
import UserInfrastructure
import AuthInfrastructure
import MediaInfrastructure

public func buildMigrations(
    connection: any DatabaseConnection
) -> [Migration] {
    [
        // Tables
        SystemInfrastructure.TableMigration(connection: connection),
        AnalyticsInfrastructure.TableMigration(connection: connection),
        WebInfrastructure.MetadataTableMigration(connection: connection),
        RedirectInfrastructure.TableMigration(connection: connection),
        WebInfrastructure.TableMigration(connection: connection),
        BlogInfrastructure.TableMigration(connection: connection),
        UserInfrastructure.TableMigration(connection: connection),
        AuthInfrastructure.TableMigration(connection: connection),
        MediaInfrastructure.TableMigration(connection: connection),
        // Seed data
        SystemInfrastructure.TableSeedMigration(connection: connection),
        AnalyticsInfrastructure.TableSeedMigration(connection: connection),
        AnalyticsInfrastructure.InsightsPermissionSeedMigration(
            connection: connection
        ),
        WebInfrastructure.MetadataTableSeedMigration(connection: connection),
        RedirectInfrastructure.TableSeedMigration(connection: connection),
        RedirectInfrastructure.NotFoundPermissionSeedMigration(
            connection: connection
        ),
        WebInfrastructure.TableSeedMigration(connection: connection),
        BlogInfrastructure.TableSeedMigration(connection: connection),
        BlogInfrastructure.SettingsPermissionSeedMigration(
            connection: connection
        ),
        UserInfrastructure.TableSeedMigration(connection: connection),
        WebInfrastructure.MetadataPermissionSeedMigration(
            connection: connection
        ),
        AuthInfrastructure.TableSeedMigration(connection: connection),
    ]
}
