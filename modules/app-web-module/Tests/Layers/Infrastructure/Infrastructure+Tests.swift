import FeatherDBAL
import FeatherDBALTesting
import FeatherDatabase
import FeatherModuleKit
import SystemApplication
import SystemModule
import Testing
import WebDomain
import WebModule

@testable import WebInfrastructure

@Suite
struct InfrastructureTests {

    @Test
    func menuTableSchemaIncludesConstraintsAndTimestamps() {
        let schema = Menu.Table.tableCreationSchema

        #expect(schema.name == "web_menu")
        #expect(
            schema.columns.map(\.name) == [
                "id", "key", "name", "notes", "created_at", "updated_at",
            ]
        )
        #expect(
            schema.columns.first(where: { $0.name == "id" })?.constraints
                .contains {
                    if case .primaryKey = $0 {
                        true
                    }
                    else {
                        false
                    }
                } == true
        )
        #expect(
            schema.columns.first(where: { $0.name == "key" })?.constraints
                .contains {
                    if case .unique = $0 {
                        true
                    }
                    else {
                        false
                    }
                } == true
        )
        #expect(schema.indexes.map(\.name).contains("web_menu_key_idx"))
        #expect(
            schema.indexes.first(where: { $0.name == "web_menu_key_idx" })?
                .columns.map(\.name) == ["key"]
        )
        for column in [schema.columns[4], schema.columns[5]] {
            #expect(
                column.constraints.contains {
                    guard case .notNull = $0 else { return false }
                    return true
                }
            )
            #expect(
                column.constraints.contains {
                    guard case .default(let value) = $0 else { return false }
                    if case .currentTimestamp = value.storage { return true }
                    return false
                }
            )
        }

        let queries = DatabaseQueryCreate(
            schema: schema,
            using: MockDatabasePlatform()
        )
        .build()

        #expect(queries.count == 2)
        #expect(queries[0].sql.contains("CREATE TABLE"))
        #expect(queries[1].sql.contains("CREATE INDEX"))
    }

    @Test
    func pageTableSchemaIncludesMediaReferenceAndIndexes() {
        let schema = Page.Table.tableCreationSchema

        #expect(
            schema.columns.map(\.name) == [
                "id", "title", "excerpt", "content", "image_asset_id",
                "created_at",
                "updated_at",
            ]
        )
        #expect(
            schema.columns[0].constraints
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
            schema.columns[2].constraints
                .contains {
                    guard case .default(let value) = $0 else { return false }
                    guard case .string(let actual) = value.storage else {
                        return false
                    }
                    return actual.isEmpty
                }
        )
        for column in [schema.columns[5], schema.columns[6]] {
            #expect(
                column.constraints.contains {
                    guard case .notNull = $0 else { return false }
                    return true
                }
            )
            #expect(
                column.constraints.contains {
                    guard case .default(let value) = $0 else { return false }
                    if case .currentTimestamp = value.storage { return true }
                    return false
                }
            )
        }
        #expect(schema.indexes.map(\.name).contains("web_page_title_idx"))
        #expect(
            schema.indexes.map { $0.columns.map(\.name) } == [
                ["title"], ["image_asset_id"],
            ]
        )
        #expect(
            schema.constraints.contains {
                if case .foreignKey(
                    columns: let columns,
                    referencesTable: "media_asset_node_file",
                    referencedColumns: let referencedColumns,
                    onDelete: .setNull,
                    onUpdate: _
                ) = $0 {
                    columns.map(\.name) == ["image_asset_id"]
                        && referencedColumns.map(\.name) == ["asset_node_id"]
                }
                else {
                    false
                }
            }
        )

        let queries = DatabaseQueryCreate(
            schema: schema,
            using: MockDatabasePlatform()
        )
        .build()

        #expect(queries.count == 3)
        #expect(queries[0].sql.contains("CREATE TABLE"))
        #expect(queries[1].sql.contains("CREATE INDEX"))
        #expect(queries[2].sql.contains("CREATE INDEX"))
    }

    @Test
    func menuItemTableSchemaIncludesRelationshipAndIndex() {
        let schema = MenuItem.Table.tableCreationSchema

        #expect(schema.name == "web_menu_item")
        #expect(
            schema.columns.map(\.name) == [
                "id", "menu_id", "label", "url", "priority", "is_blank",
                "permission", "authentication", "notes", "created_at",
                "updated_at",
            ]
        )
        #expect(
            schema.columns[0].constraints
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
            schema.columns[5].constraints
                .contains {
                    guard case .default(let value) = $0 else { return false }
                    guard case .boolean(let actual) = value.storage else {
                        return false
                    }
                    return !actual
                }
        )
        #expect(
            schema.columns[7].constraints
                .contains {
                    guard case .default(let value) = $0 else { return false }
                    guard case .string(let actual) = value.storage else {
                        return false
                    }
                    return actual == "any"
                }
        )
        for column in [schema.columns[9], schema.columns[10]] {
            #expect(
                column.constraints.contains {
                    guard case .notNull = $0 else { return false }
                    return true
                }
            )
            #expect(
                column.constraints.contains {
                    guard case .default(let value) = $0 else { return false }
                    if case .currentTimestamp = value.storage { return true }
                    return false
                }
            )
        }
        #expect(
            schema.indexes.map(\.name).contains("web_menu_item_menu_id_idx")
        )
        #expect(
            schema.indexes.first {
                $0.name == "web_menu_item_menu_id_idx"
            }?
            .columns.map(\.name) == ["menu_id"]
        )
        #expect(
            schema.constraints.contains {
                if case .foreignKey(
                    columns: let columns,
                    referencesTable: "web_menu",
                    referencedColumns: let referencedColumns,
                    onDelete: .cascade,
                    onUpdate: _
                ) = $0 {
                    columns.map(\.name) == ["menu_id"]
                        && referencedColumns.map(\.name) == ["id"]
                }
                else {
                    false
                }
            }
        )

        let queries = DatabaseQueryCreate(
            schema: schema,
            using: MockDatabasePlatform()
        )
        .build()

        #expect(queries.count == 2)
        #expect(queries[0].sql.contains("CREATE TABLE"))
        #expect(queries[1].sql.contains("CREATE INDEX"))
    }

    @Test
    func metadataTableSchemaIncludesUniqueIndexesAndTimestamps() {
        let schema = Metadata.Table.tableCreationSchema

        #expect(schema.name == "web_metadata")
        #expect(
            schema.columns.map(\.name) == [
                "id", "reference_type", "reference_id", "template", "slug",
                "publication_date", "expiration_date", "status",
                "title_override",
                "excerpt_override", "image_url_override", "canonical_url",
                "no_index",
                "primary_keyword", "css_code_injection",
                "javascript_code_injection",
                "structured_data_code_injection", "created_at", "updated_at",
            ]
        )
        #expect(
            schema.columns[0].constraints
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
            schema.columns[3].constraints
                .contains {
                    guard case .default(let value) = $0 else { return false }
                    guard case .string(let actual) = value.storage else {
                        return false
                    }
                    return actual == "default"
                }
        )
        #expect(
            schema.columns[12].constraints
                .contains {
                    guard case .default(let value) = $0 else { return false }
                    guard case .boolean(let actual) = value.storage else {
                        return false
                    }
                    return !actual
                }
        )
        for column in [
            schema.columns[5], schema.columns[17], schema.columns[18],
        ] {
            #expect(
                column.constraints.contains {
                    guard case .notNull = $0 else { return false }
                    return true
                }
            )
            #expect(
                column.constraints.contains {
                    guard case .default(let value) = $0 else { return false }
                    if case .currentTimestamp = value.storage { return true }
                    return false
                }
            )
        }
        #expect(
            schema.indexes.map(\.name)
                .contains("web_metadata_reference_owner_idx")
        )
        #expect(schema.indexes.map(\.name).contains("web_metadata_slug_idx"))
        #expect(schema.indexes.allSatisfy { $0.isUnique })
        #expect(
            schema.indexes.map { $0.columns.map(\.name) } == [
                ["reference_type", "reference_id"], ["slug"],
            ]
        )

        let queries = DatabaseQueryCreate(
            schema: schema,
            using: MockDatabasePlatform()
        )
        .build()

        #expect(queries.count == 3)
        #expect(queries[0].sql.contains("CREATE TABLE"))
        #expect(
            queries.dropFirst()
                .allSatisfy { $0.sql.contains("CREATE UNIQUE INDEX") }
        )
    }

    @Test
    func variableSeedUsesRegisteredPublicBaseURL() async throws {
        let publicBaseURL = "https://example.com"
        var events = EventRegistry()
        WebModule.Event.Handlers.register(
            in: &events,
            publicBaseURL: publicBaseURL
        )

        let variables =
            try await events.trigger(
                event: SystemModule.Variable.Event.Seed(),
                using: DefaultEventContext()
            )
            .flatMap { $0 }

        #expect(
            variables.first(where: {
                $0.key == "web-settings-public-base-url"
            })?
            .value == publicBaseURL
        )
    }
}
