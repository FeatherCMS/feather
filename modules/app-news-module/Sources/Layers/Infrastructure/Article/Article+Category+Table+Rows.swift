public import FeatherDBAL
public import NewsModule

extension Article.CategoryTable: DatabaseTableWithInsert {
    public struct Insert: DatabaseTableRowEncodable {
        public let articleId: String
        public let categoryId: String

        public init(articleId: String, categoryId: String) {
            self.articleId = articleId
            self.categoryId = categoryId
        }
    }
}

extension Article.CategoryTable: DatabaseTableWithList {
    public struct List: DatabaseTableRowDecodable {
        public let articleId: String
        public let categoryId: String
    }
}

extension Article.CategoryTable: DatabaseTableWithDelete {}
