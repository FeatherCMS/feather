import FeatherDBAL
import NewsModule
import Testing

@testable import NewsInfrastructure

@Suite
struct NewsInfrastructureTests {
    @Test
    func articleSchemaDefinesColumnsKeysAndIndexes() {
        let schema = Article.Table.tableCreationSchema

        #expect(schema.name == "news_article")
        #expect(
            schema.columns.map(\.name) == [
                "id", "title", "excerpt", "content", "image_asset_id",
                "created_at", "updated_at",
            ]
        )
        for index in [1, 2, 3] {
            #expect(schema.columns[index].constraints.contains {
                if case .notNull = $0 { true } else { false }
            })
        }
        #expect(
            schema.constraints.contains {
                guard case .primaryKey(let columns) = $0 else { return false }
                return columns.map(\.name) == ["id"]
            }
        )
        #expect(
            schema.constraints.contains {
                guard
                    case .foreignKey(
                        let columns,
                        let table,
                        let referenced,
                        let onDelete,
                        _
                    ) = $0
                else { return false }
                guard case .setNull? = onDelete else { return false }
                return columns.map(\.name) == ["image_asset_id"]
                    && table == "media_asset_node_file"
                    && referenced.map(\.name) == ["asset_node_id"]
            }
        )
        #expect(schema.columns[2].constraints.contains {
            guard case .default(let value) = $0 else { return false }
            guard case .string(let actual) = value.storage else { return false }
            return actual.isEmpty
        })
        for column in [schema.columns[5], schema.columns[6]] {
            #expect(column.constraints.contains {
                guard case .notNull = $0 else { return false }
                return true
            })
            #expect(column.constraints.contains {
                guard case .default(let value) = $0 else { return false }
                if case .currentTimestamp = value.storage { return true }
                return false
            })
        }
        #expect(
            schema.indexes.map(\.name) == [
                "news_article_title_idx", "news_article_image_asset_id_idx",
            ]
        )
        #expect(
            schema.indexes.map { $0.columns.map(\.name) } == [
                ["title"], ["image_asset_id"],
            ]
        )
    }

    @Test
    func categorySchemaDefinesColumnsKeysAndIndexes() {
        let schema = Category.Table.tableCreationSchema

        #expect(schema.name == "news_category")
        #expect(
            schema.columns.map(\.name) == [
                "id", "title", "excerpt", "content", "image_asset_id",
                "created_at", "updated_at",
            ]
        )
        for index in [1, 2, 3] {
            #expect(schema.columns[index].constraints.contains {
                if case .notNull = $0 { true } else { false }
            })
        }
        #expect(
            schema.constraints.contains {
                guard case .primaryKey(let columns) = $0 else { return false }
                return columns.map(\.name) == ["id"]
            }
        )
        #expect(
            schema.constraints.contains {
                guard
                    case .foreignKey(
                        let columns,
                        let table,
                        let referenced,
                        let onDelete,
                        _
                    ) = $0
                else { return false }
                guard case .setNull? = onDelete else { return false }
                return columns.map(\.name) == ["image_asset_id"]
                    && table == "media_asset_node_file"
                    && referenced.map(\.name) == ["asset_node_id"]
            }
        )
        #expect(schema.columns[2].constraints.contains {
            guard case .default(let value) = $0 else { return false }
            guard case .string(let actual) = value.storage else { return false }
            return actual.isEmpty
        })
        for column in [schema.columns[5], schema.columns[6]] {
            #expect(column.constraints.contains {
                guard case .notNull = $0 else { return false }
                return true
            })
            #expect(column.constraints.contains {
                guard case .default(let value) = $0 else { return false }
                if case .currentTimestamp = value.storage { return true }
                return false
            })
        }
        #expect(
            schema.indexes.map(\.name) == [
                "news_category_title_idx", "news_category_image_asset_id_idx",
            ]
        )
        #expect(
            schema.indexes.map { $0.columns.map(\.name) } == [
                ["title"], ["image_asset_id"],
            ]
        )
    }

    @Test
    func articleCategorySchemaDefinesCompositeKeyAndForeignKeys() {
        let schema = ArticleCategory.Table.tableCreationSchema

        #expect(schema.name == "news_article_category")
        #expect(
            schema.columns.map(\.name) == ["article_id", "category_id"]
        )
        for column in schema.columns {
            #expect(column.constraints.contains {
                if case .notNull = $0 { true } else { false }
            })
        }
        #expect(
            schema.constraints.contains {
                guard case .primaryKey(let columns) = $0 else { return false }
                return columns.map(\.name) == ["article_id", "category_id"]
            }
        )
        #expect(
            schema.constraints
                .filter {
                    if case .foreignKey = $0 { return true }
                    return false
                }
                .count == 2
        )
        #expect(
            schema.constraints.contains {
                guard
                    case .foreignKey(
                        let columns,
                        let table,
                        let referenced,
                        let onDelete,
                        _
                    ) = $0
                else { return false }
                guard case .cascade? = onDelete else { return false }
                return columns.map(\.name) == ["article_id"]
                    && table == Article.Table.name
                    && referenced.map(\.name) == ["id"]
            }
        )
        #expect(
            schema.constraints.contains {
                guard
                    case .foreignKey(
                        let columns,
                        let table,
                        let referenced,
                        let onDelete,
                        _
                    ) = $0
                else { return false }
                guard case .cascade? = onDelete else { return false }
                return columns.map(\.name) == ["category_id"]
                    && table == Category.Table.name
                    && referenced.map(\.name) == ["id"]
            }
        )
        #expect(
            schema.indexes.map(\.name) == [
                "news_article_category_category_id_idx"
            ]
        )
        #expect(
            schema.indexes[0].columns.map(\.name) == ["category_id"]
        )
    }
}
