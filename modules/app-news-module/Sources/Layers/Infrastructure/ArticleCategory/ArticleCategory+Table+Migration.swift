import FeatherDBAL
import NewsModule

extension ArticleCategory.Table {
    static var tableCreationSchema: DatabaseTableSchema {
        .init(
            name: name,
            columns: [
                .init(
                    name: columns.articleId.name,
                    type: .string,
                    constraints: [.notNull]
                ),
                .init(
                    name: columns.categoryId.name,
                    type: .string,
                    constraints: [.notNull]
                ),
            ],
            constraints: [
                .primaryKey([
                    .init(name: columns.articleId.name, type: .string),
                    .init(name: columns.categoryId.name, type: .string),
                ]),
                .foreignKey(
                    columns: [
                        .init(name: columns.articleId.name, type: .string)
                    ],
                    referencesTable: Article.Table.name,
                    referencedColumns: [
                        .init(
                            name: Article.Table.columns.id.name,
                            type: .string
                        )
                    ],
                    onDelete: .cascade,
                    onUpdate: nil
                ),
                .foreignKey(
                    columns: [
                        .init(name: columns.categoryId.name, type: .string)
                    ],
                    referencesTable: Category.Table.name,
                    referencedColumns: [
                        .init(
                            name: Category.Table.columns.id.name,
                            type: .string
                        )
                    ],
                    onDelete: .cascade,
                    onUpdate: nil
                ),
            ],
            indexes: [
                .init(
                    name: "news_article_category_category_id_idx",
                    columns: [
                        .init(name: columns.categoryId.name, type: .string)
                    ]
                )
            ]
        )
    }
}
