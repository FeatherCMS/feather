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
        #expect(profile.columns[0].constraints.contains {
            if case .primaryKey = $0 { true } else { false }
        })
        #expect(profile.columns[1].constraints.contains {
            if case .notNull = $0 { true } else { false }
        })
        #expect(profile.columns[5].type == .timestamp)
        #expect(profile.columns[6].type == .timestamp)
        for column in [profile.columns[5], profile.columns[6]] {
            #expect(column.constraints.contains {
                if case .notNull = $0 { true } else { false }
            })
            #expect(column.constraints.contains {
                guard case .default(let value) = $0 else { return false }
                if case .currentTimestamp = value.storage { return true }
                return false
            })
        }
        #expect(
            profile.indexes.map(\.name) == [
                "account_profile_image_asset_id_idx"
            ]
        )
        #expect(
            profile.constraints.contains {
                if case .unique(let columns) = $0 {
                    columns.map(\.name) == ["user_id"]
                }
                else {
                    false
                }
            }
        )
        #expect(
            profile.constraints.contains {
                if case .foreignKey(
                    columns: let columns,
                    referencesTable: "user_identity",
                    referencedColumns: let referencedColumns,
                    onDelete: .cascade,
                    onUpdate: _
                ) = $0 {
                    columns.map(\.name) == ["user_id"]
                        && referencedColumns.map(\.name) == ["id"]
                }
                else {
                    false
                }
            }
        )
        #expect(
            profile.constraints.contains {
                if case .foreignKey(
                    columns: let columns,
                    referencesTable: "media_asset_node_file",
                    referencedColumns: let referencedColumns,
                    onDelete: .setNull,
                    onUpdate: _
                ) = $0 {
                    columns.map(\.name) == ["profile_image_asset_id"]
                        && referencedColumns.map(\.name) == ["asset_node_id"]
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
        #expect(settings.columns[0].constraints.contains {
            if case .primaryKey = $0 { true } else { false }
        })
        #expect(settings.columns[1].constraints.contains {
            if case .notNull = $0 { true } else { false }
        })
        #expect(settings.columns[2].constraints.contains {
            guard case .default(let value) = $0 else { return false }
            guard case .string(let actual) = value.storage else { return false }
            return actual == "en"
        })
        #expect(settings.columns[3].constraints.contains {
            if case .notNull = $0 { true } else { false }
        })
        #expect(settings.columns[4].constraints.contains {
            guard case .default(let value) = $0 else { return false }
            guard case .integer(let actual) = value.storage else { return false }
            return actual == 20
        })
        for column in [settings.columns[5], settings.columns[6]] {
            #expect(column.constraints.contains {
                if case .notNull = $0 { true } else { false }
            })
            #expect(column.constraints.contains {
                guard case .default(let value) = $0 else { return false }
                if case .currentTimestamp = value.storage { return true }
                return false
            })
        }
        #expect(
            settings.constraints.contains {
                if case .foreignKey(
                    columns: let columns,
                    referencesTable: "user_identity",
                    referencedColumns: let referencedColumns,
                    onDelete: .cascade,
                    onUpdate: _
                ) = $0 {
                    columns.map(\.name) == ["user_id"]
                        && referencedColumns.map(\.name) == ["id"]
                }
                else {
                    false
                }
            }
        )
        #expect(
            settings.constraints.contains {
                if case .unique(let columns) = $0 {
                    columns.map(\.name) == ["user_id"]
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
        #expect(invitation.columns[0].constraints.contains {
            if case .primaryKey = $0 { true } else { false }
        })
        for index in [1, 2, 3, 4, 5] {
            #expect(invitation.columns[index].constraints.contains {
                if case .notNull = $0 { true } else { false }
            })
        }
        #expect(invitation.columns[3].constraints.contains {
            if case .unique = $0 { true } else { false }
        })
        #expect(invitation.columns[4].constraints.contains {
            guard case .default(let value) = $0 else { return false }
            guard case .string(let actual) = value.storage else { return false }
            return actual == "[]"
        })
        for column in [invitation.columns[6], invitation.columns[7]] {
            #expect(column.constraints.contains {
                if case .notNull = $0 { true } else { false }
            })
            #expect(column.constraints.contains {
                guard case .default(let value) = $0 else { return false }
                if case .currentTimestamp = value.storage { return true }
                return false
            })
        }
        #expect(
            invitation.constraints.contains {
                if case .foreignKey(
                    columns: let columns,
                    referencesTable: "user_identity",
                    referencedColumns: let referencedColumns,
                    onDelete: .cascade,
                    onUpdate: _
                ) = $0 {
                    columns.map(\.name) == ["user_id"]
                        && referencedColumns.map(\.name) == ["id"]
                }
                else {
                    false
                }
            }
        )
    }
}
