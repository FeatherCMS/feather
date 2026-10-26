import FeatherDBALTesting
import FeatherDatabase
import FeatherDatabaseTesting
import FeatherInfrastructure
import Testing
import UserModule

@testable import FeatherDBAL
@testable import UserInfrastructure

private enum QueryKey: DatabaseQueryKey {
    case migration
}

@Suite
struct UserInfrastructureDatabaseTests {

    @Test
    func tableMigrationCreatesUserTables() async throws {
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
        #expect(queries?.contains { $0.sql.contains("user_identity") } == true)
        #expect(queries?.contains { $0.sql.contains("user_role") } == true)
        #expect(
            queries?.contains { $0.sql.contains("user_identity_role") }
                == true
        )
    }

    @Test
    func tableSchemasDeclareColumnsConstraintsAndIndexes() {
        let identity = Identity.Table.tableCreationSchema
        let role = Role.Table.tableCreationSchema
        let identityRole = IdentityRole.Table.tableCreationSchema

        #expect(identity.name == "user_identity")
        #expect(role.name == "user_role")
        #expect(identityRole.name == "user_identity_role")
        #expect(
            identity.columns.map(\.name) == [
                "id", "name", "status", "is_root", "created_at", "updated_at",
            ]
        )
        #expect(identity.columns[0].type == .string)
        #expect(
            identity.columns[0].constraints
                .contains {
                    if case .primaryKey = $0 {
                        true
                    }
                    else {
                        false
                    }
                }
        )
        #expect(
            identity.columns[3].constraints
                .contains {
                    if case .default = $0 {
                        true
                    }
                    else {
                        false
                    }
                }
        )
        #expect(identity.columns[1].constraints.contains {
            if case .notNull = $0 { true } else { false }
        })
        #expect(identity.columns[2].constraints.contains {
            if case .notNull = $0 { true } else { false }
        })
        #expect(identity.columns[4].type == .timestamp)
        #expect(
            identity.columns[4].constraints
                .contains {
                    if case .default = $0 {
                        true
                    }
                    else {
                        false
                    }
                }
        )
        #expect(identity.columns[5].type == .timestamp)
        #expect(
            identity.columns[5].constraints
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
            hasBooleanDefault(identity.columns[3].constraints, value: false)
        )
        #expect(hasCurrentTimestampDefault(identity.columns[4].constraints))
        #expect(hasCurrentTimestampDefault(identity.columns[5].constraints))
        for column in [identity.columns[4], identity.columns[5]] {
            #expect(column.constraints.contains {
                if case .notNull = $0 { true } else { false }
            })
        }

        #expect(
            role.columns.map(\.name) == [
                "id", "key", "name", "notes", "created_at", "updated_at",
            ]
        )
        #expect(
            role.columns[0].constraints
                .contains {
                    if case .primaryKey = $0 { true } else { false }
                }
        )
        #expect(
            role.columns[1].constraints
                .contains {
                    if case .notNull = $0 {
                        true
                    }
                    else {
                        false
                    }
                }
        )
        #expect(
            role.columns[1].constraints
                .contains {
                    if case .unique = $0 {
                        true
                    }
                    else {
                        false
                    }
                }
        )
        #expect(role.columns[4].type == .timestamp)
        #expect(
            role.columns[4].constraints
                .contains {
                    if case .default = $0 {
                        true
                    }
                    else {
                        false
                    }
                }
        )
        #expect(role.columns[5].type == .timestamp)
        #expect(
            role.columns[5].constraints
                .contains {
                    if case .default = $0 {
                        true
                    }
                    else {
                        false
                    }
                }
        )
        #expect(hasCurrentTimestampDefault(role.columns[4].constraints))
        #expect(hasCurrentTimestampDefault(role.columns[5].constraints))
        for column in [role.columns[4], role.columns[5]] {
            #expect(column.constraints.contains {
                if case .notNull = $0 { true } else { false }
            })
        }

        #expect(
            identityRole.columns.map(\.name) == [
                "role_id", "identity_id", "created_at", "updated_at",
            ]
        )
        #expect(identityRole.columns[2].type == .timestamp)
        #expect(
            identityRole.columns[2].constraints
                .contains {
                    if case .default = $0 {
                        true
                    }
                    else {
                        false
                    }
                }
        )
        #expect(identityRole.columns[3].type == .timestamp)
        #expect(
            identityRole.columns[3].constraints
                .contains {
                    if case .default = $0 {
                        true
                    }
                    else {
                        false
                    }
                }
        )
        #expect(hasCurrentTimestampDefault(identityRole.columns[2].constraints))
        #expect(hasCurrentTimestampDefault(identityRole.columns[3].constraints))
        for column in [identityRole.columns[2], identityRole.columns[3]] {
            #expect(column.constraints.contains {
                if case .notNull = $0 { true } else { false }
            })
        }
        #expect(
            identityRole.constraints.contains {
                guard case .primaryKey(let columns) = $0 else { return false }
                return columns.map(\.name) == ["role_id", "identity_id"]
            }
        )
        #expect(
            identityRole.constraints
                .filter {
                    if case .foreignKey = $0 {
                        true
                    }
                    else {
                        false
                    }
                }
                .count == 2
        )
        #expect(
            identityRole.constraints.contains {
                guard
                    case .foreignKey(
                        let
                            columns,
                        let table,
                        let referencedColumns,
                        let onDelete,
                        _
                    ) = $0
                else { return false }
                guard case .cascade? = onDelete else { return false }
                return columns.map(\.name) == ["role_id"]
                    && table == Role.Table.name
                    && referencedColumns.map(\.name) == ["id"]
            }
        )
        #expect(
            identityRole.constraints.contains {
                guard
                    case .foreignKey(
                        let
                            columns,
                        let table,
                        let referencedColumns,
                        let onDelete,
                        _
                    ) = $0
                else { return false }
                guard case .cascade? = onDelete else { return false }
                return columns.map(\.name) == ["identity_id"]
                    && table == Identity.Table.name
                    && referencedColumns.map(\.name) == ["id"]
            }
        )
        #expect(
            identityRole.indexes.map(\.name) == [
                "user_identity_role_identity_id_idx"
            ]
        )
        #expect(identityRole.indexes[0].columns.map(\.name) == ["identity_id"])
    }
}

private func hasBooleanDefault(
    _ constraints: [DatabaseTableColumnConstraintSchema],
    value expected: Bool
) -> Bool {
    constraints.contains { constraint in
        guard case .default(let value) = constraint else { return false }
        guard case .boolean(let actual) = value.storage else { return false }
        return actual == expected
    }
}

private func hasCurrentTimestampDefault(
    _ constraints: [DatabaseTableColumnConstraintSchema]
) -> Bool {
    constraints.contains { constraint in
        guard case .default(let value) = constraint else { return false }
        if case .currentTimestamp = value.storage { return true }
        return false
    }
}
