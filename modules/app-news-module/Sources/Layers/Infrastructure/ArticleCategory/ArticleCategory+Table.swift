public import FeatherDBAL
public import NewsModule

extension ArticleCategory {
    public struct Table: DatabaseTable {
        public static let name = "news_article_category"
        public static let columns = Columns()

        public struct Columns: DatabaseTableColumns {
            public let articleId = DatabaseTableColumn<String>(
                name: "article_id"
            )
            public let categoryId = DatabaseTableColumn<String>(
                name: "category_id"
            )
        }
    }
}
