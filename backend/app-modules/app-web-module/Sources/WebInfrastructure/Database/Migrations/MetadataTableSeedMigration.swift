import Infrastructure
import FeatherDatabase

public struct MetadataTableSeedMigration: DatabaseMigration {

    public let connection: any DatabaseConnection

    public init(
        connection: any DatabaseConnection
    ) {
        self.connection = connection
    }

    public func apply(
        on connection: any DatabaseConnection
    ) async throws {
        try await connection.run(
            query: #"""
                INSERT INTO web_metadata (
                    id,
                    reference_type,
                    reference_id,
                    slug,
                    publication_date,
                    expiration_date,
                    status,
                    title_override,
                    excerpt_override,
                    image_url_override,
                    canonical_url,
                    no_index,
                    primary_keyword,
                    css_code_injection,
                    javascript_code_injection,
                    structured_data_code_injection,
                    created_at,
                    updated_at
                )
                SELECT
                    'meta_web_page_' || web_page.id,
                    'web.page',
                    web_page.id,
                    'web-page-' || LOWER(web_page.id),
                    NULL,
                    NULL,
                    'draft',
                    NULL,
                    NULL,
                    NULL,
                    '',
                    FALSE,
                    '',
                    '',
                    '',
                    '',
                    web_page.created_at,
                    web_page.updated_at
                FROM web_page
                WHERE NOT EXISTS (
                    SELECT 1
                    FROM web_metadata
                    WHERE reference_type = 'web.page'
                        AND reference_id = web_page.id
                );
                """#
        ) { _ in }
        try await connection.run(
            query: #"""
                INSERT INTO web_metadata (
                    id,
                    reference_type,
                    reference_id,
                    slug,
                    publication_date,
                    expiration_date,
                    status,
                    title_override,
                    excerpt_override,
                    image_url_override,
                    canonical_url,
                    no_index,
                    primary_keyword,
                    css_code_injection,
                    javascript_code_injection,
                    structured_data_code_injection,
                    created_at,
                    updated_at
                )
                SELECT
                    'meta_blog_post_' || blog_post.id,
                    'blog.post',
                    blog_post.id,
                    'blog-post-' || LOWER(blog_post.id),
                    NULL,
                    NULL,
                    'draft',
                    NULL,
                    NULL,
                    NULL,
                    '',
                    FALSE,
                    '',
                    '',
                    '',
                    '',
                    blog_post.created_at,
                    blog_post.updated_at
                FROM blog_post
                WHERE NOT EXISTS (
                    SELECT 1
                    FROM web_metadata
                    WHERE reference_type = 'blog.post'
                        AND reference_id = blog_post.id
                );
                """#
        ) { _ in }
        try await connection.run(
            query: #"""
                INSERT INTO web_metadata (
                    id,
                    reference_type,
                    reference_id,
                    slug,
                    publication_date,
                    expiration_date,
                    status,
                    title_override,
                    excerpt_override,
                    image_url_override,
                    canonical_url,
                    no_index,
                    primary_keyword,
                    css_code_injection,
                    javascript_code_injection,
                    structured_data_code_injection,
                    created_at,
                    updated_at
                )
                SELECT
                    'meta_blog_author_' || blog_author.id,
                    'blog.author',
                    blog_author.id,
                    'blog-author-' || LOWER(blog_author.id),
                    NULL,
                    NULL,
                    'draft',
                    NULL,
                    NULL,
                    NULL,
                    '',
                    FALSE,
                    '',
                    '',
                    '',
                    '',
                    blog_author.created_at,
                    blog_author.updated_at
                FROM blog_author
                WHERE NOT EXISTS (
                    SELECT 1
                    FROM web_metadata
                    WHERE reference_type = 'blog.author'
                        AND reference_id = blog_author.id
                );
                """#
        ) { _ in }
        try await connection.run(
            query: #"""
                INSERT INTO web_metadata (
                    id,
                    reference_type,
                    reference_id,
                    slug,
                    publication_date,
                    expiration_date,
                    status,
                    title_override,
                    excerpt_override,
                    image_url_override,
                    canonical_url,
                    no_index,
                    primary_keyword,
                    css_code_injection,
                    javascript_code_injection,
                    structured_data_code_injection,
                    created_at,
                    updated_at
                )
                SELECT
                    'meta_blog_tag_' || blog_tag.id,
                    'blog.tag',
                    blog_tag.id,
                    'blog-tag-' || LOWER(blog_tag.id),
                    NULL,
                    NULL,
                    'draft',
                    NULL,
                    NULL,
                    NULL,
                    '',
                    FALSE,
                    '',
                    '',
                    '',
                    '',
                    blog_tag.created_at,
                    blog_tag.updated_at
                FROM blog_tag
                WHERE NOT EXISTS (
                    SELECT 1
                    FROM web_metadata
                    WHERE reference_type = 'blog.tag'
                        AND reference_id = blog_tag.id
                );
                """#
        ) { _ in }
    }
}
