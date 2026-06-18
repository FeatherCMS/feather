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
            INSERT INTO web_page (
                id,
                title,
                content,
                image_asset_id,
                created_at,
                updated_at
            )
            VALUES
                (
                    'sample-web-page',
                    'Welcome Page',
                    '<h1>Welcome</h1><p>This seeded page gives a clean setup a working public page immediately.</p>',
                    NULL,
                    NOW(),
                    NOW()
                ),
                (
                    'sample-article-page',
                    'Product Update Article',
                    '<h1>Product Update</h1><p>This seeded article page is intended for menu and route verification.</p>',
                    NULL,
                    NOW(),
                    NOW()
                )
            ON CONFLICT DO NOTHING;
            """#,
            #"""
            INSERT INTO web_menu (
                id,
                key,
                name,
                notes,
                created_at,
                updated_at
            )
            VALUES (
                'sample-main-menu',
                'main',
                'Main Menu',
                'Seeded main navigation for clean local setups.',
                NOW(),
                NOW()
            )
            ON CONFLICT DO NOTHING;
            """#,
            #"""
            INSERT INTO web_menu_item (
                id,
                menu_id,
                label,
                url,
                priority,
                is_blank,
                permission,
                notes,
                created_at,
                updated_at
            )
            VALUES
                (
                    'sample-menu-item-blog-post',
                    'sample-main-menu',
                    'Blog Post',
                    '/posts/welcome-to-the-blog/',
                    10,
                    FALSE,
                    '',
                    'Seeded link to the sample blog post.',
                    NOW(),
                    NOW()
                ),
                (
                    'sample-menu-item-article',
                    'sample-main-menu',
                    'Article',
                    '/product-update-article/',
                    20,
                    FALSE,
                    '',
                    'Seeded link to the sample article page.',
                    NOW(),
                    NOW()
                ),
                (
                    'sample-menu-item-tag',
                    'sample-main-menu',
                    'Tag',
                    '/tags/getting-started/',
                    30,
                    FALSE,
                    '',
                    'Seeded link to the sample blog tag.',
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
            VALUES
                (
                    'meta_sample_web_page',
                    'web.page',
                    'sample-web-page',
                    'welcome',
                    NOW(),
                    NULL,
                    'published',
                    NULL,
                    NULL,
                    NULL,
                    '',
                    FALSE,
                    'sample web page',
                    '',
                    '',
                    '',
                    NOW(),
                    NOW()
                ),
                (
                    'meta_sample_article_page',
                    'web.page',
                    'sample-article-page',
                    'product-update-article',
                    NOW(),
                    NULL,
                    'published',
                    NULL,
                    NULL,
                    NULL,
                    '',
                    FALSE,
                    'sample article page',
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
