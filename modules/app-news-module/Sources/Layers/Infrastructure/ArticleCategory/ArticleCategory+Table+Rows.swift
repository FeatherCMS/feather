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
    }
}

extension ArticleCategory.Table: DatabaseTableWithList {
    public struct List: DatabaseTableRowDecodable {
        public let articleId: String
        public let categoryId: String
    }
}

extension ArticleCategory.Table: DatabaseTableWithDelete {}
