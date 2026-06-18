import Infrastructure
import FeatherDatabase

public struct TableSeedMigration: DatabaseMigration {

    public let connection: any DatabaseConnection

    public init(
        connection: any DatabaseConnection
    ) {
        self.connection = connection
    }

    public func apply(
        on connection: any DatabaseConnection
    ) async throws {
        let queries: [DatabaseQuery] = [
            #"""
            INSERT INTO blog_author (
                id,
                key,
                name,
                notes,
                profile_image_asset_id,
                content,
                created_at,
                updated_at
            )
            VALUES (
                'sample-blog-author',
                'sample-author',
                'Sample Author',
                'Seeded author for local content verification.',
                NULL,
                '<p>This is a seeded author profile used by the sample blog post.</p>',
                NOW(),
                NOW()
            )
            ON CONFLICT DO NOTHING;
            """#,
            #"""
            INSERT INTO blog_tag (
                id,
                title,
                content,
                image_asset_id,
                created_at,
                updated_at
            )
            VALUES (
                'sample-blog-tag',
                'Getting Started',
                'Starter tag for seeded blog content.',
                NULL,
                NOW(),
                NOW()
            )
            ON CONFLICT DO NOTHING;
            """#,
            #"""
            INSERT INTO blog_post (
                id,
                title,
                content,
                image_asset_id,
                author_ids,
                tag_ids,
                created_at,
                updated_at
            )
            VALUES (
                'sample-blog-post',
                'Welcome to the Blog',
                '<p>This is a seeded blog post for clean local setups.</p><p>Use it to verify content routing, metadata, and admin flows.</p>',
                NULL,
                '["sample-blog-author"]',
                '["sample-blog-tag"]',
                NOW(),
                NOW()
            )
            ON CONFLICT DO NOTHING;
            """#,
            #"""
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
            VALUES (
                'meta_sample_blog_author',
                'blog.author',
                'sample-blog-author',
                'authors/sample-author',
                NOW(),
                NULL,
                'published',
                NULL,
                NULL,
                NULL,
                '',
                FALSE,
                'sample blog author',
                '',
                '',
                '',
                NOW(),
                NOW()
            )
            ON CONFLICT DO NOTHING;
            """#,
            #"""
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
            VALUES (
                'meta_sample_blog_post',
                'blog.post',
                'sample-blog-post',
                'posts/welcome-to-the-blog',
                NOW(),
                NULL,
                'published',
                NULL,
                NULL,
                NULL,
                '',
                FALSE,
                'sample blog post',
                '',
                '',
                '',
                NOW(),
                NOW()
            )
            ON CONFLICT DO NOTHING;
            """#,
            #"""
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
            VALUES (
                'meta_sample_blog_tag',
                'blog.tag',
                'sample-blog-tag',
                'tags/getting-started',
                NOW(),
                NULL,
                'published',
                NULL,
                NULL,
                NULL,
                '',
                FALSE,
                'sample blog tag',
                '',
                '',
                '',
                NOW(),
                NOW()
            )
            ON CONFLICT DO NOTHING;
            """#,
        ]

        for query in queries {
            try await connection.run(query: query) { _ in }
        }
    }
}
