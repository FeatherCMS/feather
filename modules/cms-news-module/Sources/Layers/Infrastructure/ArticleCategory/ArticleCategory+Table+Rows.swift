public import FeatherDBAL
public import NewsModule

extension ArticleCategory.Table: DatabaseTableWithInsert {
    public struct Insert: DatabaseTableRowEncodable {
        public let articleId: String
        public let categoryId: String

        public init(articleId: String, categoryId: String) {
            self.articleId = articleId
            self.categoryId = categoryId
        }

        enum CodingKeys: String, CodingKey {
            case articleId = "article_id"
            case categoryId = "category_id"
        }
    }
}

extension ArticleCategory.Table: DatabaseTableWithList {
    public struct List: DatabaseTableRowDecodable {
        public let articleId: String
        public let categoryId: String

        enum CodingKeys: String, CodingKey {
            case articleId = "article_id"
            case categoryId = "category_id"
        }
    }
}

extension ArticleCategory.Table: DatabaseTableWithDelete {}
