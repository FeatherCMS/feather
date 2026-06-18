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
            // MARK: - permission
            #"""
            INSERT INTO system_permission (
                id,
                name,
                notes,
                created_at,
                updated_at
            )
            VALUES
                -- Auth permissions (current naming)
                ('auth:admin:access', 'auth:admin:access', 'Access the admin dashboard and admin application shell.', NOW(), NOW()),
                ('auth:magic-links:create', 'auth:magic-links:create', 'Create a magic link.', NOW(), NOW()),
                ('auth:magic-links:read', 'auth:magic-links:read', 'View a single magic link.', NOW(), NOW()),
                ('auth:magic-links:update', 'auth:magic-links:update', 'Edit a magic link.', NOW(), NOW()),
                ('auth:magic-links:list', 'auth:magic-links:list', 'List and search magic links.', NOW(), NOW()),
                ('auth:magic-links:delete', 'auth:magic-links:delete', 'Delete a magic link.', NOW(), NOW()),
                ('auth:access-control:create', 'auth:access-control:create', 'Assign a permission to a role.', NOW(), NOW()),
                ('auth:access-control:read', 'auth:access-control:read', 'View a specific role-permission assignment.', NOW(), NOW()),
                ('auth:access-control:update', 'auth:access-control:update', 'Update role-permission assignments.', NOW(), NOW()),
                ('auth:access-control:list', 'auth:access-control:list', 'List and search role-permission assignments.', NOW(), NOW()),
                ('auth:access-control:delete', 'auth:access-control:delete', 'Remove a permission from a role.', NOW(), NOW()),
                ('auth:profile:read', 'auth:profile:read', 'View the current account profile.', NOW(), NOW()),
                ('auth:profile:update', 'auth:profile:update', 'Edit the current account profile.', NOW(), NOW()),
                ('auth:settings:read', 'auth:settings:read', 'View the current account settings.', NOW(), NOW()),
                ('auth:settings:update', 'auth:settings:update', 'Edit the current account settings.', NOW(), NOW()),
                ('auth:sessions:create', 'auth:sessions:create', 'Create a session.', NOW(), NOW()),
                ('auth:sessions:read', 'auth:sessions:read', 'View a single session.', NOW(), NOW()),
                ('auth:sessions:update', 'auth:sessions:update', 'Extend or update a session.', NOW(), NOW()),
                ('auth:sessions:list', 'auth:sessions:list', 'List sessions.', NOW(), NOW()),
                ('auth:sessions:delete', 'auth:sessions:delete', 'Remove a session.', NOW(), NOW()),

                -- User permissions (current naming)
                ('user:accounts:create', 'user:accounts:create', 'Create a user account.', NOW(), NOW()),
                ('user:accounts:read', 'user:accounts:read', 'View a single user account.', NOW(), NOW()),
                ('user:accounts:update', 'user:accounts:update', 'Edit a user account.', NOW(), NOW()),
                ('user:accounts:list', 'user:accounts:list', 'List and search user accounts.', NOW(), NOW()),
                ('user:accounts:delete', 'user:accounts:delete', 'Delete a user account.', NOW(), NOW()),
                ('user:accounts:me', 'user:accounts:me', 'Treat the current account as self-managed profile/settings access.', NOW(), NOW()),
                ('user:roles:create', 'user:roles:create', 'Create a role.', NOW(), NOW()),
                ('user:roles:read', 'user:roles:read', 'View a single role.', NOW(), NOW()),
                ('user:roles:update', 'user:roles:update', 'Edit a role.', NOW(), NOW()),
                ('user:roles:list', 'user:roles:list', 'List and search roles.', NOW(), NOW()),
                ('user:roles:delete', 'user:roles:delete', 'Delete a role.', NOW(), NOW()),
                ('user:invitations:create', 'user:invitations:create', 'Create an invitation.', NOW(), NOW()),
                ('user:invitations:read', 'user:invitations:read', 'View a single invitation.', NOW(), NOW()),
                ('user:invitations:list', 'user:invitations:list', 'List and search invitations.', NOW(), NOW()),
                ('user:invitations:update', 'user:invitations:update', 'Edit an invitation.', NOW(), NOW()),
                ('user:invitations:delete', 'user:invitations:delete', 'Delete an invitation.', NOW(), NOW()),

                -- System permissions (current naming)
                ('system:permissions:create', 'system:permissions:create', 'Create a system permission entry.', NOW(), NOW()),
                ('system:permissions:read', 'system:permissions:read', 'View a single system permission.', NOW(), NOW()),
                ('system:permissions:update', 'system:permissions:update', 'Edit a system permission.', NOW(), NOW()),
                ('system:permissions:list', 'system:permissions:list', 'List and search system permissions.', NOW(), NOW()),
                ('system:permissions:delete', 'system:permissions:delete', 'Delete a system permission.', NOW(), NOW()),
                ('system:variables:create', 'system:variables:create', 'Create a system variable.', NOW(), NOW()),
                ('system:variables:read', 'system:variables:read', 'View a single system variable.', NOW(), NOW()),
                ('system:variables:update', 'system:variables:update', 'Edit a system variable.', NOW(), NOW()),
                ('system:variables:list', 'system:variables:list', 'List and search system variables.', NOW(), NOW()),
                ('system:variables:delete', 'system:variables:delete', 'Delete a system variable.', NOW(), NOW()),

                -- Analytics permissions
                ('analytics:logs:list', 'analytics:logs:list', 'List, search, and inspect raw analytics logs.', NOW(), NOW()),
                ('analytics:insights:list', 'analytics:insights:list', 'View analytics overview and insights dashboards.', NOW(), NOW()),

                -- Redirect permissions
                ('redirect:rules:create', 'redirect:rules:create', 'Create a redirect rule.', NOW(), NOW()),
                ('redirect:rules:read', 'redirect:rules:read', 'View a single redirect rule.', NOW(), NOW()),
                ('redirect:rules:update', 'redirect:rules:update', 'Edit a redirect rule.', NOW(), NOW()),
                ('redirect:rules:list', 'redirect:rules:list', 'List and search redirect rules.', NOW(), NOW()),
                ('redirect:rules:delete', 'redirect:rules:delete', 'Delete a redirect rule.', NOW(), NOW()),
                ('redirect:not-found:list', 'redirect:not-found:list', 'View 404 and missing-route reports.', NOW(), NOW()),

                -- Blog permissions
                ('blog:posts:create', 'blog:posts:create', 'Create a blog post.', NOW(), NOW()),
                ('blog:posts:read', 'blog:posts:read', 'View a single blog post.', NOW(), NOW()),
                ('blog:posts:update', 'blog:posts:update', 'Edit a blog post.', NOW(), NOW()),
                ('blog:posts:list', 'blog:posts:list', 'List and search blog posts.', NOW(), NOW()),
                ('blog:posts:delete', 'blog:posts:delete', 'Delete a blog post.', NOW(), NOW()),
                ('blog:tags:create', 'blog:tags:create', 'Create a blog tag.', NOW(), NOW()),
                ('blog:tags:read', 'blog:tags:read', 'View a single blog tag.', NOW(), NOW()),
                ('blog:tags:update', 'blog:tags:update', 'Edit a blog tag.', NOW(), NOW()),
                ('blog:tags:list', 'blog:tags:list', 'List and search blog tags.', NOW(), NOW()),
                ('blog:tags:delete', 'blog:tags:delete', 'Delete a blog tag.', NOW(), NOW()),
                ('blog:authors:create', 'blog:authors:create', 'Create a blog author.', NOW(), NOW()),
                ('blog:authors:read', 'blog:authors:read', 'View a single blog author.', NOW(), NOW()),
                ('blog:authors:update', 'blog:authors:update', 'Edit a blog author.', NOW(), NOW()),
                ('blog:authors:list', 'blog:authors:list', 'List and search blog authors.', NOW(), NOW()),
                ('blog:authors:delete', 'blog:authors:delete', 'Delete a blog author.', NOW(), NOW()),
                ('blog:author-links:create', 'blog:author-links:create', 'Create an author link.', NOW(), NOW()),
                ('blog:author-links:read', 'blog:author-links:read', 'View a single author link.', NOW(), NOW()),
                ('blog:author-links:update', 'blog:author-links:update', 'Edit an author link.', NOW(), NOW()),
                ('blog:author-links:list', 'blog:author-links:list', 'List and search author links.', NOW(), NOW()),
                ('blog:author-links:delete', 'blog:author-links:delete', 'Delete an author link.', NOW(), NOW()),
                ('blog:settings:read', 'blog:settings:read', 'View blog settings.', NOW(), NOW()),
                ('blog:settings:update', 'blog:settings:update', 'Edit blog settings.', NOW(), NOW()),

                -- Web permissions
                ('web:pages:create', 'web:pages:create', 'Create a page.', NOW(), NOW()),
                ('web:pages:read', 'web:pages:read', 'View a single page.', NOW(), NOW()),
                ('web:pages:update', 'web:pages:update', 'Edit a page.', NOW(), NOW()),
                ('web:pages:list', 'web:pages:list', 'List and search pages.', NOW(), NOW()),
                ('web:pages:delete', 'web:pages:delete', 'Delete a page.', NOW(), NOW()),
                ('web:menus:create', 'web:menus:create', 'Create a menu.', NOW(), NOW()),
                ('web:menus:read', 'web:menus:read', 'View a single menu.', NOW(), NOW()),
                ('web:menus:update', 'web:menus:update', 'Edit a menu.', NOW(), NOW()),
                ('web:menus:list', 'web:menus:list', 'List and search menus.', NOW(), NOW()),
                ('web:menus:delete', 'web:menus:delete', 'Delete a menu.', NOW(), NOW()),
                ('web:menu-items:create', 'web:menu-items:create', 'Create a menu item.', NOW(), NOW()),
                ('web:menu-items:read', 'web:menu-items:read', 'View a single menu item.', NOW(), NOW()),
                ('web:menu-items:update', 'web:menu-items:update', 'Edit a menu item.', NOW(), NOW()),
                ('web:menu-items:list', 'web:menu-items:list', 'List and search menu items.', NOW(), NOW()),
                ('web:menu-items:delete', 'web:menu-items:delete', 'Delete a menu item.', NOW(), NOW()),
                ('web:settings:read', 'web:settings:read', 'View web settings.', NOW(), NOW()),
                ('web:settings:update', 'web:settings:update', 'Edit web settings.', NOW(), NOW()),

                -- Media permissions
                ('media:assets:create', 'media:assets:create', 'Create or upload a media asset. Also covers media folder creation.', NOW(), NOW()),
                ('media:assets:read', 'media:assets:read', 'View a single media asset.', NOW(), NOW()),
                ('media:assets:update', 'media:assets:update', 'Edit a media asset. Also covers media folder editing.', NOW(), NOW()),
                ('media:assets:list', 'media:assets:list', 'List and search media assets. Also covers media folder browsing.', NOW(), NOW()),
                ('media:assets:delete', 'media:assets:delete', 'Delete a media asset. Also covers media folder deletion.', NOW(), NOW()),
                ('media:processors:create', 'media:processors:create', 'Create a media processor.', NOW(), NOW()),
                ('media:processors:read', 'media:processors:read', 'View a single media processor.', NOW(), NOW()),
                ('media:processors:list', 'media:processors:list', 'List and search media processors.', NOW(), NOW()),
                ('media:processors:update', 'media:processors:update', 'Edit a media processor.', NOW(), NOW()),
                ('media:processors:delete', 'media:processors:delete', 'Delete a media processor.', NOW(), NOW())
            ON CONFLICT (id) DO NOTHING;
            """#,
            // MARK: - variable
            #"""
            INSERT INTO system_variable (
                id,
                name,
                value,
                notes,
                created_at,
                updated_at
            )
            VALUES
                ('blog-settings-post-list-path', 'blog.post.list_path', 'blog', 'Public blog post list path.', NOW(), NOW()),
                ('blog-settings-author-list-path', 'blog.author.list_path', 'authors', 'Public blog author list path.', NOW(), NOW()),
                ('blog-settings-tag-list-path', 'blog.tag.list_path', 'tags', 'Public blog tag list path.', NOW(), NOW()),
                ('blog-settings-post-path-prefix', 'blog.post.path_prefix', 'posts', 'Public blog post detail path prefix.', NOW(), NOW()),
                ('blog-settings-author-path-prefix', 'blog.author.path_prefix', 'authors', 'Public blog author detail path prefix.', NOW(), NOW()),
                ('blog-settings-tag-path-prefix', 'blog.tag.path_prefix', 'tags', 'Public blog tag detail path prefix.', NOW(), NOW()),
                ('web-settings-logo', 'web.site.logo', '', 'Logo of the website', NOW(), NOW()),
                ('web-settings-logo-dark', 'web.site.logo_dark', '', 'Logo of the website in dark mode', NOW(), NOW()),
                ('web-settings-meta-image', 'web.site.meta_image', '', 'Default metadata image of the website', NOW(), NOW()),
                ('web-settings-primary-color', 'web.site.primary_color', '', 'Primary color of the website', NOW(), NOW()),
                ('web-settings-secondary-color', 'web.site.secondary_color', '', 'Secondary color of the website', NOW(), NOW()),
                ('web-settings-tertiary-color', 'web.site.tertiary_color', '', 'Tertiary color of the website', NOW(), NOW()),
                ('web-settings-primary-font', 'web.site.primary_font', '', 'Primary font of the website', NOW(), NOW()),
                ('web-settings-secondary-font', 'web.site.secondary_font', '', 'Secondary font of the website', NOW(), NOW()),
                ('web-settings-home-page-id', 'web.site.home_page_id', '', 'Selected home page of the website', NOW(), NOW()),
                ('web-settings-locale', 'web.site.locale', 'en_us', 'Default locale of the website', NOW(), NOW()),
                ('web-settings-timezone', 'web.site.timezone', 'utc', 'Default timezone of the website', NOW(), NOW()),
                ('web-settings-title', 'web.site.title', '', 'Title of the website', NOW(), NOW()),
                ('web-settings-excerpt', 'web.site.excerpt', '', 'Excerpt for the website', NOW(), NOW()),
                ('web-settings-no-index', 'web.site.no_index', 'false', 'Disable site indexing by search engines', NOW(), NOW()),
                ('web-settings-css', 'web.site.css', '', 'Global CSS injection for the site', NOW(), NOW()),
                ('web-settings-js', 'web.site.js', '', 'Global JavaScript injection for the site', NOW(), NOW())
            ON CONFLICT (name) DO NOTHING;
            """#,
        ]

        for query in queries {
            try await connection.run(query: query) { _ in }
        }
    }
}
