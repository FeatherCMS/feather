import FeatherContracts
public import FeatherDatabase
public import FeatherInfrastructure
import NewsDomain
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
        let category = try await CategoryDatabaseRepository(
            context: context
        )
        .insert(
            Category.create(
                title: "Getting Started",
                excerpt: "Starter category for seeded news content.",
                content: "Starter category for seeded news content.",
                metadata: .init(
                    template: "news.category",
                    slug: "Getting Started"
                        .prefixedSlug(with: "news/categories"),
                    status: .published
                )
            )
        )

        _ = try await ArticleDatabaseRepository(
            context: context
        )
        .insert(
            Article.create(
                title: "Welcome to the News",
                excerpt:
                    "A sample news article for local content verification.",
                content:
                    "This is a seeded news article for clean local setups.",
                categoryIds: [category.id],
                metadata: .init(
                    template: "news.article",
                    slug: "Welcome to the News".prefixedSlug(with: "news"),
                    status: .published
                )
            )
        )
    }
}
