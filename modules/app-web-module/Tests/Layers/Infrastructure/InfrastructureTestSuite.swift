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
struct InfrastructureTestSuite {

    @Test
    func menuTableSchemaIncludesConstraintsAndTimestamps() {
        let schema = Menu.Table.tableCreationSchema

        #expect(schema.name == "web_menu")
        #expect(schema.columns.map(\.name).contains("created_at"))
        #expect(schema.columns.map(\.name).contains("updated_at"))
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

        #expect(schema.columns.map(\.name).contains("created_at"))
        #expect(schema.columns.map(\.name).contains("updated_at"))
        #expect(schema.indexes.map(\.name).contains("web_page_title_idx"))
        #expect(
            schema.constraints.contains {
                if case .foreignKey(
                    columns: _,
                    referencesTable: "media_asset_node_file",
                    referencedColumns: _,
                    onDelete: .setNull,
                    onUpdate: _
                ) = $0 {
                    true
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
        #expect(schema.columns.map(\.name).contains("created_at"))
        #expect(schema.columns.map(\.name).contains("updated_at"))
        #expect(
            schema.indexes.map(\.name).contains("web_menu_item_menu_id_idx")
        )
        #expect(
            schema.constraints.contains {
                if case .foreignKey(
                    columns: _,
                    referencesTable: "web_menu",
                    referencedColumns: _,
                    onDelete: .cascade,
                    onUpdate: _
                ) = $0 {
                    true
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
        #expect(schema.columns.map(\.name).contains("created_at"))
        #expect(schema.columns.map(\.name).contains("updated_at"))
        #expect(
            schema.indexes.map(\.name)
                .contains("web_metadata_reference_owner_idx")
        )
        #expect(schema.indexes.map(\.name).contains("web_metadata_slug_idx"))
        #expect(schema.indexes.allSatisfy { $0.isUnique })

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
