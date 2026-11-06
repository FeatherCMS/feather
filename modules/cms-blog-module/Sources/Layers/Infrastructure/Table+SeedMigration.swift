import BlogDomain
import BlogModule
import FeatherDBAL
import FeatherDomain
public import FeatherDatabase
public import FeatherInfrastructure
import FeatherModuleKit
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
        let author = try await Author.Repository
            .Database(
                context: context
            )
            .insert(
                Author.Model.create(
                    name: "Sample Author",
                    excerpt: "Seeded author for local content verification.",
                    content: #"""
                        This is a seeded author for clean local setups.

                        Use it to verify content routing, metadata, and admin flows.</p>
                        """#,
                    metadata: .init(
                        template: "blog.author",
                        slug: Slug(parsing: "authors")
                            .appending("Sample Author")
                            .path,
                        status: .published
                    )
                )
            )

        let tag = try await Tag.Repository
            .Database(
                context: context
            )
            .insert(
                Tag.Model.create(
                    title: "Getting Started",
                    excerpt: "Starter tag for seeded blog content.",
                    content: #"""
                        This is a seeded tag for clean local setups.

                        Use it to verify content routing, metadata, and admin flows.</p>
                        """#,
                    metadata: .init(
                        template: "blog.tag",
                        slug: Slug(parsing: "tags")
                            .appending("Getting Started")
                            .path,
                        status: .published
                    )
                )
            )

        _ = try await Post.Repository
            .Database(
                context: context
            )
            .insert(
                Post.Model.create(
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
                        slug: Slug(parsing: "posts")
                            .appending("Welcome to the Blog")
                            .path,
                        status: .published
                    )
                )
            )

    }
}
