//
//  BlogInfrastructureTestSuite.swift
//  app-blog-module
//
//  Created by Binary Birds on 2026. 07. 16.

import BlogModule
import FeatherDBAL
import FeatherDBALTesting
import FeatherDatabase
import FeatherDatabaseTesting
import Testing

@testable import BlogInfrastructure

private enum QueryKey: DatabaseQueryKey {
    case migration
}

@Suite
struct BlogInfrastructureTestSuite {

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

        #expect(post.columns.map(\.name).contains("created_at"))
        #expect(post.columns.map(\.name).contains("updated_at"))
        #expect(tag.columns.map(\.name).contains("created_at"))
        #expect(tag.columns.map(\.name).contains("updated_at"))
        #expect(author.columns.map(\.name).contains("created_at"))
        #expect(author.columns.map(\.name).contains("updated_at"))
        #expect(authorLink.columns.map(\.name).contains("created_at"))
        #expect(authorLink.columns.map(\.name).contains("updated_at"))

        #expect(
            author.columns.first(where: { $0.name == "id" })?.constraints
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
        #expect(post.indexes.map(\.name).contains("blog_post_title_idx"))
        #expect(tag.indexes.map(\.name).contains("blog_tag_title_idx"))
        #expect(
            authorLink.indexes.map(\.name)
                .contains("blog_author_link_author_id_idx")
        )

        #expect(
            author.constraints.contains {
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
        #expect(
            authorLink.constraints.contains {
                if case .foreignKey(
                    columns: _,
                    referencesTable: "blog_author",
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
    }
}
