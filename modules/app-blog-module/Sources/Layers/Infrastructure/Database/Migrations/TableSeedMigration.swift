import BlogDomain
import FeatherContracts
public import FeatherDatabase
public import FeatherInfrastructure
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
