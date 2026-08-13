import BlogDomain
import FeatherContracts
import FeatherDatabase
import FeatherDomain
import FeatherInfrastructure
import WebDomain

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
        let author = try await AuthorDatabaseRepository(
            context: context
        )
        .insert(
            Author.create(
                name: "Sample Author",
                excerpt: "Seeded author for local content verification.",
                content: #"""
                    This is a seeded author for clean local setups.

                    Use it to verify content routing, metadata, and admin flows.</p>
                    """#,
                metadata: .init(
                    template: "blog.author",
                    slug: "Sample Author".prefixedSlug(with: "authors"),
                    status: .published
                )
            )
        )

        let tag = try await TagDatabaseRepository(
            context: context
        )
        .insert(
            Tag.create(
                title: "Getting Started",
                excerpt: "Starter tag for seeded blog content.",
                content: #"""
                    This is a seeded tag for clean local setups.

                    Use it to verify content routing, metadata, and admin flows.</p>
                    """#,
                metadata: .init(
                    template: "blog.tag",
                    slug: "Getting Started".prefixedSlug(with: "tags"),
                    status: .published
                )
            )
        )

        _ = try await PostDatabaseRepository(
            context: context
        )
        .insert(
            Post.create(
                title: "Welcome to the Blog",
                excerpt: "A seeded blog post for clean local setups.",
                content: #"""
                    This is a seeded blog post for clean local setups.

                    Use it to verify content routing, metadata, and admin flows.</p>
                    """#,
                authorIds: [author.id],
                tagIds: [tag.id],
                metadata: .init(
                    template: "blog.post",
                    slug: "Welcome to the Blog".prefixedSlug(with: "posts"),
                    status: .published
                )
            )
        )

    }
}
