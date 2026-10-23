import FeatherDBAL
import NewsModule
import Testing

@testable import NewsInfrastructure

@Suite
struct NewsInfrastructureTestSuite {
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
        #expect(
            schema.indexes.map(\.name) == [
                "news_article_title_idx", "news_article_image_asset_id_idx",
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
        #expect(
            schema.indexes.map(\.name) == [
                "news_category_title_idx", "news_category_image_asset_id_idx",
            ]
        )
    }

    @Test
    func articleCategorySchemaDefinesCompositeKeyAndForeignKeys() {
        let schema = Article.CategoryTable.tableCreationSchema

        #expect(schema.name == "news_article_category")
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
            schema.indexes.map(\.name) == [
                "news_article_category_category_id_idx"
            ]
        )
    }
}
