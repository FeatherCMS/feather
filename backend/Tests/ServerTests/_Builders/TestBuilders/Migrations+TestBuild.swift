import FeatherDatabase
import Infrastructure
import SystemInfrastructure
import UserInfrastructure
import AuthInfrastructure
import MediaInfrastructure
import WebInfrastructure

public func buildTestMigrations(
    connection: any DatabaseConnection
) -> [Migration] {
    [
        // Tables
        SystemInfrastructure.TableMigration(connection: connection),
        UserInfrastructure.TableMigration(connection: connection),
        AuthInfrastructure.TableMigration(connection: connection),
        MediaInfrastructure.TableMigration(connection: connection),
        WebInfrastructure.TableMigration(connection: connection),
        WebInfrastructure.MetadataTableMigration(connection: connection),
        // Seed data
        SystemInfrastructure.TableSeedMigration(connection: connection),
        UserInfrastructure.TableSeedMigration(connection: connection),
        AuthInfrastructure.TableSeedMigration(connection: connection),
        WebInfrastructure.MetadataPermissionSeedMigration(
            connection: connection
        ),
        WebInfrastructure.TableSeedMigration(connection: connection),
    ]
}
