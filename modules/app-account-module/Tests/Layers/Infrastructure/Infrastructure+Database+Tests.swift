import AccountModule
import FeatherDBAL
import FeatherDBALTesting
import FeatherDatabase
import FeatherDatabaseTesting
import Testing

@testable import AccountInfrastructure

private enum QueryKey: DatabaseQueryKey {
    case migration
}

@Suite
struct InfrastructureDatabaseTests {
    @Test
    func migrationCreatesAccountTables() async throws {
        let connection = MockDatabaseConnection<QueryKey>(
            responses: (0..<4).map { _ in .init(key: .migration) }
        )
        let migration = TableMigration(
            connection: connection,
            platform: MockDatabasePlatform()
        )

        try await migration.apply(on: connection)
        try await connection.assertAllResponsesConsumed()

        let queries = await connection.executedQueries()[.migration]
        #expect(queries?.count == 4)
        #expect(
            queries?.contains { $0.sql.contains("account_profile") } == true
        )
        #expect(
            queries?.contains { $0.sql.contains("account_settings") } == true
        )
        #expect(
            queries?.contains { $0.sql.contains("account_invitation") } == true
        )
    }

    @Test
    func accountTablesDeclareColumnsAndConstraints() {
        let profile = Profile.Table.tableCreationSchema
        let settings = Settings.Table.tableCreationSchema
        let invitation = Invitation.Table.tableCreationSchema

        #expect(
            profile.columns.map(\.name) == [
                "id", "user_id", "first_name", "last_name",
                "profile_image_asset_id", "created_at", "updated_at",
            ]
        )
        #expect(profile.columns[5].type == .timestamp)
        #expect(hasDefault(profile.columns[5].constraints))
        #expect(profile.columns[6].type == .timestamp)
        #expect(hasDefault(profile.columns[6].constraints))
        #expect(
            profile.indexes.map(\.name) == [
                "account_profile_image_asset_id_idx"
            ]
        )
        #expect(
            profile.constraints.contains {
                if case .unique = $0 {
                    true
                }
                else {
                    false
                }
            }
        )
        #expect(
            profile.constraints.contains {
                if case .foreignKey = $0 {
                    true
                }
                else {
                    false
                }
            }
        )

        #expect(
            settings.columns.map(\.name) == [
                "id", "user_id", "language", "timezone", "page_size",
                "created_at", "updated_at",
            ]
        )
        #expect(
            settings.columns[2].constraints
                .contains {
                    if case .default = $0 {
                        true
                    }
                    else {
                        false
                    }
                }
        )
        #expect(
            settings.columns[4].constraints
                .contains {
                    if case .default = $0 {
                        true
                    }
                    else {
                        false
                    }
                }
        )
        #expect(settings.columns[5].type == .timestamp)
        #expect(hasDefault(settings.columns[5].constraints))
        #expect(settings.columns[6].type == .timestamp)
        #expect(hasDefault(settings.columns[6].constraints))
        #expect(
            settings.constraints.contains {
                if case .unique = $0 {
                    true
                }
                else {
                    false
                }
            }
        )

        #expect(
            invitation.columns.map(\.name) == [
                "id", "user_id", "email", "token", "role_ids", "expires_at",
                "created_at", "updated_at",
            ]
        )
        #expect(invitation.columns[4].type == .string)
        #expect(
            invitation.columns[4].constraints
                .contains {
                    if case .default = $0 {
                        true
                    }
                    else {
                        false
                    }
                }
        )
        #expect(invitation.columns[6].type == .timestamp)
        #expect(hasDefault(invitation.columns[6].constraints))
        #expect(invitation.columns[7].type == .timestamp)
        #expect(hasDefault(invitation.columns[7].constraints))
        #expect(
            invitation.constraints.contains {
                if case .foreignKey = $0 {
                    true
                }
                else {
                    false
                }
            }
        )
    }
}

private func hasDefault(
    _ constraints: [DatabaseTableColumnConstraintSchema]
) -> Bool {
    constraints.contains {
        if case .default = $0 {
            true
        }
        else {
            false
        }
    }
}
