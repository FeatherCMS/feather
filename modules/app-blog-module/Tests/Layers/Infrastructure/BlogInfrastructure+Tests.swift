//
//  BlogInfrastructure+Tests.swift
//  app-blog-module
//
//  Created by Binary Birds on 2026. 07. 16.

import BlogApplication
import BlogModule
import FeatherDBAL
import FeatherDBALTesting
import FeatherDatabase
import FeatherDatabaseTesting
import FeatherInfrastructure
import FeatherTesting
import Foundation
import Testing

@testable import BlogInfrastructure
@testable import FeatherDBAL

private enum QueryKey: DatabaseQueryKey {
    case migration
    case authorList
}

@Suite
struct BlogInfrastructureTests {

    @Test
    func migrationCreatesEveryBlogTableAndIndex() async throws {
        let connection = MockDatabaseConnection<QueryKey>(
            responses: Array(repeating: .init(key: .migration), count: 11)
        )
        let migration = TableMigration(
            connection: connection,
            platform: MockDatabasePlatform()
        )

        try await migration.apply(on: connection)
        try await connection.assertAllResponsesConsumed()

        let queries = await connection.executedQueries()[.migration]
        #expect(queries?.count == 11)
        #expect(queries?.filter { $0.sql.contains("CREATE TABLE") }.count == 4)
        #expect(queries?.filter { $0.sql.contains("CREATE INDEX") }.count == 7)
        #expect(queries?.contains { $0.sql.contains("blog_post") } == true)
        #expect(queries?.contains { $0.sql.contains("blog_tag") } == true)
        #expect(queries?.contains { $0.sql.contains("blog_author") } == true)
        #expect(
            queries?.contains { $0.sql.contains("blog_author_link") } == true
        )
    }

    @Test
    func tableSchemasDeclareTimestampsKeysAndIndexes() {
        let post = Post.Table.tableCreationSchema
        let tag = Tag.Table.tableCreationSchema
        let author = Author.Table.tableCreationSchema
        let authorLink = AuthorLink.Table.tableCreationSchema

        #expect(
            post.columns.map(\.name) == [
                "id", "title", "excerpt", "content", "image_asset_id",
                "author_ids", "tag_ids", "created_at", "updated_at",
            ]
        )
        #expect(
            tag.columns.map(\.name) == [
                "id", "title", "excerpt", "content", "image_asset_id",
                "created_at", "updated_at",
            ]
        )
        #expect(
            author.columns.map(\.name) == [
                "id", "key", "name", "notes", "excerpt",
                "profile_image_asset_id", "content", "created_at",
                "updated_at",
            ]
        )
        #expect(
            authorLink.columns.map(\.name) == [
                "id", "author_id", "label", "url", "priority", "is_blank",
                "permission", "notes", "created_at", "updated_at",
            ]
        )

        for schema in [post, tag, author, authorLink] {
            for name in ["created_at", "updated_at"] {
                let column = schema.columns.first(where: { $0.name == name })
                #expect(
                    column?.constraints
                        .contains {
                            if case .notNull = $0 {
                                true
                            }
                            else {
                                false
                            }
                        } == true
                )
                #expect(
                    column.map { hasCurrentTimestampDefault($0.constraints) }
                        == true
                )
            }
        }

        #expect(
            post.columns.first(where: { $0.name == "author_ids" })
                .map {
                    hasStringDefault($0.constraints, value: "[]")
                } == true
        )
        #expect(
            post.columns.first(where: { $0.name == "tag_ids" })
                .map {
                    hasStringDefault($0.constraints, value: "[]")
                } == true
        )
        #expect(
            author.columns.first(where: { $0.name == "excerpt" })
                .map {
                    hasStringDefault($0.constraints, value: "")
                } == true
        )
        #expect(
            author.columns.first(where: { $0.name == "content" })
                .map {
                    hasStringDefault($0.constraints, value: "")
                } == true
        )
        #expect(
            post.columns.first(where: { $0.name == "excerpt" })
                .map {
                    hasStringDefault($0.constraints, value: "")
                } == true
        )
        #expect(
            tag.columns.first(where: { $0.name == "excerpt" })
                .map {
                    hasStringDefault($0.constraints, value: "")
                } == true
        )
        #expect(
            authorLink.columns.first(where: { $0.name == "is_blank" })
                .map {
                    hasBooleanDefault($0.constraints, value: false)
                } == true
        )

        for schema in [post, tag, author, authorLink] {
            #expect(
                schema.columns.first(where: { $0.name == "id" })?
                    .constraints
                    .contains {
                        if case .primaryKey = $0 {
                            true
                        }
                        else {
                            false
                        }
                    } == true
            )
        }
        #expect(
            author.columns.first(where: { $0.name == "key" })?.constraints
                .contains {
                    if case .unique = $0 {
                        true
                    }
                    else {
                        false
                    }
                } == true
        )
        #expect(
            Set(post.indexes.map(\.name)) == [
                "blog_post_title_idx",
                "blog_post_image_asset_id_idx",
            ]
        )
        #expect(
            Set(tag.indexes.map(\.name)) == [
                "blog_tag_title_idx",
                "blog_tag_image_asset_id_idx",
            ]
        )
        #expect(
            Set(author.indexes.map(\.name)) == [
                "blog_author_key_idx",
                "blog_author_profile_image_asset_id_idx",
            ]
        )
        #expect(
            authorLink.indexes.map(\.name)
                == ["blog_author_link_author_id_idx"]
        )

        #expect(
            author.constraints.contains {
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
            authorLink.constraints.contains {
                if case .foreignKey(
                    columns: let columns,
                    referencesTable: "blog_author",
                    referencedColumns: let referencedColumns,
                    onDelete: .cascade,
                    onUpdate: _
                ) = $0 {
                    columns.map(\.name) == ["author_id"]
                        && referencedColumns.map(\.name) == ["id"]
                }
                else {
                    false
                }
            }
        )
        #expect(
            post.constraints.contains {
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
        #expect(
            tag.constraints.contains {
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
    }

    @Test
    func authorListQueryMapsDatabaseRowsToListItems() async throws {
        let createdAt = Date(timeIntervalSince1970: 1_700_000_000)
        let updatedAt = Date(timeIntervalSince1970: 1_700_000_100)
        let connection = MockDatabaseConnection<QueryKey>(
            responses: [
                .init(
                    key: .authorList,
                    rows: [
                        .init([
                            "id": .string("author-1"),
                            "name": .string("Ada Lovelace"),
                            "excerpt": .string("Mathematician"),
                            "profile_image_asset_id": .null,
                            "created_at": .date(createdAt),
                            "updated_at": .date(updatedAt),
                        ])
                    ]
                )
            ]
        )
        let query = Author.List.Query.Database(
            context: DatabaseQueryContext(
                platform: MockDatabasePlatform(),
                connection: connection,
                idGenerator: FeatherTesting.IDGenerator.Mock(id: "unused")
            )
        )

        let output = try await query.list()
        try await connection.assertAllResponsesConsumed()

        #expect(output.items.count == 1)
        #expect(output.items.first?.id == "author-1")
        #expect(output.items.first?.name == "Ada Lovelace")
        #expect(output.items.first?.excerpt == "Mathematician")
        #expect(output.items.first?.profileImageAssetId == nil)
        #expect(output.items.first?.createdAt == createdAt)
        #expect(output.items.first?.updatedAt == updatedAt)
        let queries = await connection.executedQueries()
        #expect(queries[.authorList]?.first?.sql.contains("SELECT") == true)
        #expect(queries[.authorList]?.first?.sql.contains("ORDER BY") == true)
    }
}

private func hasStringDefault(
    _ constraints: [DatabaseTableColumnConstraintSchema],
    value expected: String
) -> Bool {
    constraints.contains { constraint in
        guard case .default(let value) = constraint else { return false }
        guard case .string(let actual) = value.storage else { return false }
        return actual == expected
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
