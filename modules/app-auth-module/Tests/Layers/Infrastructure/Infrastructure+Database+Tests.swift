import AuthApplication
import AuthModule
import FeatherApplication
import FeatherDBALTesting
import FeatherDatabase
import FeatherDatabaseTesting
import FeatherInfrastructure
import FeatherTesting
import Foundation
import Testing

@testable import AuthInfrastructure
@testable import FeatherDBAL

private enum QueryKey: DatabaseQueryKey {
    case migration
    case credentialSearch
    case credentialCount
}

@Suite
struct InfrastructureDatabaseTests {
    @Test
    func migrationCreatesAuthTablesWithRequiredColumnsConstraintsAndIndexes()
        async throws
    {
        let connection = MockDatabaseConnection<QueryKey>(
            responses: (0..<10).map { _ in .init(key: .migration) }
        )
        let migration = TableMigration(
            connection: connection,
            platform: MockDatabasePlatform()
        )

        try await migration.apply(on: connection)
        try await connection.assertAllResponsesConsumed()

        let queries = await connection.executedQueries()[.migration] ?? []
        #expect(queries.count == 10)

        let schema = queries.map(\.sql).joined(separator: "\n")
        for table in [
            "auth_session",
            "auth_email",
            "auth_email_credential",
            "auth_magic_link",
            "auth_role_permission",
        ] {
            #expect(schema.contains(table))
        }
    }

    @Test
    func tableSchemasDescribeAllColumnsForeignKeysAndIndexes() {
        let schemas = [
            Email.Table.tableCreationSchema,
            Credential.Table.tableCreationSchema,
            MagicLink.Table.tableCreationSchema,
            RolePermission.Table.tableCreationSchema,
            Session.Table.tableCreationSchema,
        ]
        let expectedColumns: [[String]] = [
            ["id", "identity_id", "email", "created_at", "updated_at"],
            [
                "id", "auth_email_id", "password_hash", "created_at",
                "updated_at",
            ],
            [
                "id", "auth_email_id", "token", "expires_at", "is_persistent",
                "is_used", "created_at", "updated_at",
            ],
            ["role_id", "permission_id", "created_at", "updated_at"],
            [
                "id", "token", "identity_id", "authentication_type",
                "authentication_reference", "is_persistent", "created_at",
                "updated_at", "expires_at",
            ],
        ]
        let requiredColumns: [[String]] = [
            ["identity_id", "email"],
            ["auth_email_id", "password_hash"],
            ["auth_email_id", "token", "expires_at", "is_persistent", "is_used"],
            ["role_id", "permission_id"],
            [
                "token", "identity_id", "authentication_type",
                "authentication_reference", "is_persistent", "expires_at",
            ],
        ]

        for index in schemas.indices {
            let schema = schemas[index]
            #expect(schema.columns.map(\.name) == expectedColumns[index])
            #expect(schema.columns.contains { $0.name == "created_at" })
            #expect(schema.columns.contains { $0.name == "updated_at" })
            for name in requiredColumns[index] {
                #expect(schema.columns.first { $0.name == name }?.constraints.contains {
                    if case .notNull = $0 { true } else { false }
                } == true)
            }
        }
        for schema in [schemas[0], schemas[1], schemas[2], schemas[4]] {
            #expect(
                schema.constraints.contains {
                    if case .primaryKey(let columns) = $0 {
                        columns.map(\.name) == ["id"]
                    }
                    else {
                        false
                    }
                }
            )
        }

        #expect(hasUniqueConstraint(schemas[0].columns[2].constraints))
        #expect(hasUniqueConstraint(schemas[1].columns[1].constraints))
        #expect(hasUniqueConstraint(schemas[2].columns[2].constraints))
        #expect(hasUniqueConstraint(schemas[4].columns[1].constraints))
        #expect(
            schemas[0].constraints.contains {
                if case .foreignKey(
                    columns: let columns,
                    referencesTable: "user_identity",
                    referencedColumns: let referencedColumns,
                    onDelete: .cascade,
                    onUpdate: _
                ) = $0 {
                    columns.map(\.name) == ["identity_id"]
                        && referencedColumns.map(\.name) == ["id"]
                }
                else {
                    false
                }
            }
        )
        #expect(
            schemas[1].constraints.contains {
                if case .foreignKey(
                    columns: let columns,
                    referencesTable: "auth_email",
                    referencedColumns: let referencedColumns,
                    onDelete: .cascade,
                    onUpdate: _
                ) = $0 {
                    columns.map(\.name) == ["auth_email_id"]
                        && referencedColumns.map(\.name) == ["id"]
                }
                else {
                    false
                }
            }
        )
        #expect(
            schemas[2].constraints.contains {
                if case .foreignKey(
                    columns: let columns,
                    referencesTable: "auth_email",
                    referencedColumns: let referencedColumns,
                    onDelete: .cascade,
                    onUpdate: _
                ) = $0 {
                    columns.map(\.name) == ["auth_email_id"]
                        && referencedColumns.map(\.name) == ["id"]
                }
                else {
                    false
                }
            }
        )
        #expect(
            schemas[3].indexes.map(\.name)
                == ["auth_role_permission_permission_id_idx"]
        )
        #expect(
            schemas[3].constraints.contains {
                if case .foreignKey(
                    columns: let columns,
                    referencesTable: "user_role",
                    referencedColumns: let referencedColumns,
                    onDelete: .cascade,
                    onUpdate: _
                ) = $0 {
                    columns.map(\.name) == ["role_id"]
                        && referencedColumns.map(\.name) == ["id"]
                }
                else {
                    false
                }
            }
        )
        #expect(
            schemas[3].constraints.contains {
                if case .foreignKey(
                    columns: let columns,
                    referencesTable: "system_permission",
                    referencedColumns: let referencedColumns,
                    onDelete: .cascade,
                    onUpdate: _
                ) = $0 {
                    columns.map(\.name) == ["permission_id"]
                        && referencedColumns.map(\.name) == ["id"]
                }
                else {
                    false
                }
            }
        )
        for (index, schema) in schemas.enumerated() {
            for name in ["created_at", "updated_at"] {
                let column = schema.columns.first { $0.name == name }
                #expect(column?.type == .timestamp)
                #expect(column?.constraints.contains {
                    guard case .notNull = $0 else { return false }
                    return true
                } == true)
                if index != 3 {
                    #expect(column?.constraints.contains {
                        guard case .default(let value) = $0 else { return false }
                        if case .currentTimestamp = value.storage { return true }
                        return false
                    } == true)
                }
            }
        }
        for schema in [schemas[2], schemas[4]] {
            for columnName in ["is_persistent", "is_used"] where
                schema.columns.contains(where: { $0.name == columnName })
            {
                #expect(schema.columns.first { $0.name == columnName }?.constraints.contains {
                    guard case .default(let value) = $0 else { return false }
                    guard case .boolean(let actual) = value.storage else { return false }
                    return !actual
                } == true)
            }
        }
        #expect(
            schemas[0].indexes.map(\.name) == []
        )
        #expect(
            schemas[1].indexes.map(\.name)
                == ["auth_email_credential_auth_email_id_idx"]
        )
        #expect(
            schemas[2].indexes.map(\.name) == [
                "auth_magic_link_auth_email_id_idx"
            ]
        )
        #expect(
            schemas[4].indexes.map(\.name) == ["auth_session_identity_id_idx"]
        )
        #expect(
            schemas[3].constraints
                .contains {
                    if case .primaryKey(let columns) = $0 {
                        columns.map(\.name) == ["role_id", "permission_id"]
                    }
                    else {
                        false
                    }
                }
        )
        #expect(
            schemas[3].constraints
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
            schemas[4].constraints.contains {
                if case .foreignKey(
                    columns: let columns,
                    referencesTable: "user_identity",
                    referencedColumns: let referencedColumns,
                    onDelete: .cascade,
                    onUpdate: _
                ) = $0 {
                    columns.map(\.name) == ["identity_id"]
                        && referencedColumns.map(\.name) == ["id"]
                }
                else {
                    false
                }
            }
        )
    }

    @Test
    func credentialSearchQueryUsesJoinedFiltersPaginationAndCount() async throws {
        let date = Date(timeIntervalSince1970: 1_700_000_000)
        let connection = MockDatabaseConnection<QueryKey>(
            responses: [
                .init(
                    key: .credentialSearch,
                    rows: [
                        .init([
                            "id": .string("credential-1"),
                            "user_id": .string("identity-1"),
                            "identity_name": .string("Ada Lovelace"),
                            "email": .string("ada@example.test"),
                            "created_at": .date(date),
                            "updated_at": .date(date),
                        ])
                    ]
                ),
                .init(
                    key: .credentialCount,
                    rows: [.init(["count": .int(1)])]
                ),
            ]
        )
        let context = DatabaseQueryContext(
            platform: MockDatabasePlatform(),
            connection: connection,
            idGenerator: FeatherTesting.IDGenerator.Mock(id: "unused")
        )
        let query = Credential.Search.Query.Database(context: context)
        let input = Credential.Search.Input.Query(
            page: .init(size: 10, number: 2),
            sort: [.init(field: .email, direction: .desc)],
            search: "ada"
        )

        let output = try await query.search(query: input, userId: nil)
        try await connection.assertAllResponsesConsumed()

        #expect(output.items.map(\.email) == ["ada@example.test"])
        #expect(output.items.first?.identityName == "Ada Lovelace")
        #expect(output.total == 1)
        let queries = await connection.executedQueries()
        let searchQuery = try #require(queries[.credentialSearch]?.first)
        #expect(searchQuery.sql.contains("INNER JOIN auth_email"))
        #expect(searchQuery.sql.contains("INNER JOIN user_identity"))
        #expect(searchQuery.sql.contains("ORDER BY email DESC"))
        #expect(searchQuery.sql.contains("LIMIT"))
        #expect(searchQuery.sql.contains("OFFSET"))
        #expect(
            searchQuery.bindings.contains(
                where: { $0.binding == .string("ada") }
            )
        )
        #expect(
            queries[.credentialCount]?.first?.sql.contains("COUNT(*)") == true
        )
    }
}

private func hasUniqueConstraint(
    _ constraints: [DatabaseTableColumnConstraintSchema]
) -> Bool {
    constraints.contains { constraint in
        if case .unique = constraint {
            true
        }
        else {
            false
        }
    }
}
