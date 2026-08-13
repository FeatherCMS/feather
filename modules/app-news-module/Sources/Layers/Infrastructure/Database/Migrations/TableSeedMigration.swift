import FeatherContracts
import FeatherDatabase
import FeatherDomain
import FeatherInfrastructure
import NewsDomain
import WebDomain
import WebInfrastructure

public struct TableSeedMigration: DatabaseMigration {
    public let connection: any DatabaseConnection
    private let idGenerator: any IDGenerator

    public init(
        connection: any DatabaseConnection,
        idGenerator: any IDGenerator
    ) {
        self.connection = connection
        self.idGenerator = idGenerator
    }

    public func apply(
        on connection: any DatabaseConnection
    ) async throws {
        let context = DatabaseTransactionContext(
            connection: connection,
            idGenerator: idGenerator
        )
        let category = try await CategoryDatabaseRepository(
            context: context
        )
        .insert(
            Category.create(
                title: "Getting Started",
                excerpt: "Starter category for seeded news content.",
                content: "<p>Starter category for seeded news content.</p>",
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
                    "<p>This is a seeded news article for clean local setups.</p>",
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
