import FeatherDBAL
import FeatherDomain
public import FeatherDatabase
public import FeatherInfrastructure
import FeatherModuleKit
import NewsDomain
import NewsModule
import WebDomain

public struct TableSeedMigration: DatabaseMigration {
    public let context: DatabaseTransactionContext

    public var connection: any DatabaseConnection {
        context.connection
    }

    public init(
        context: DatabaseTransactionContext
    ) {
        self.context = context
    }

    public func apply(
        on connection: any DatabaseConnection
    ) async throws {
        let category = try await Category.Repository
            .Database(
                context: context
            )
            .insert(
                Category.Model.create(
                    title: "Getting Started",
                    excerpt: "Starter category for seeded news content.",
                    content: "Starter category for seeded news content.",
                    metadata: .init(
                        template: "news.category",
                        slug: Slug(parsing: "news/categories")
                            .appending("Getting Started")
                            .path,
                        status: .published
                    )
                )
            )

        _ = try await Article.Repository
            .Database(
                context: context
            )
            .insert(
                Article.Model.create(
                    title: "Welcome to the News",
                    excerpt:
                        "A sample news article for local content verification.",
                    content:
                        "This is a seeded news article for clean local setups.",
                    categoryIds: [category.id],
                    metadata: .init(
                        template: "news.article",
                        slug: Slug(parsing: "news")
                            .appending("Welcome to the News")
                            .path,
                        status: .published
                    )
                )
            )
    }
}
