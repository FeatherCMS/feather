# Backend Permissions

This file documents the backend permission keys and what they allow a user to do.

## Auth

- `auth:admin:access`: Access the admin dashboard and admin application shell.

- `auth:magic-links:create`: Create a magic link.
- `auth:magic-links:read`: View a single magic link.
- `auth:magic-links:update`: Edit a magic link.
- `auth:magic-links:list`: List and search magic links.
- `auth:magic-links:delete`: Delete a magic link.

- `auth:access-control:create`: Assign a permission to a role.
- `auth:access-control:read`: View a specific role-permission assignment.
- `auth:access-control:update`: Update role-permission assignments.
- `auth:access-control:list`: List and search role-permission assignments.
- `auth:access-control:delete`: Remove a permission from a role.

- `auth:profile:read`: View the current account profile.
- `auth:profile:update`: Edit the current account profile.

- `auth:settings:read`: View the current account settings.
- `auth:settings:update`: Edit the current account settings.

- `auth:sessions:create`: Create a session.
- `auth:sessions:read`: View a single session.
- `auth:sessions:update`: Extend or update a session.
- `auth:sessions:list`: List sessions.
- `auth:sessions:delete`: Remove a session.

## User

- `user:accounts:create`: Create a user account.
- `user:accounts:read`: View a single user account.
- `user:accounts:update`: Edit a user account.
- `user:accounts:list`: List and search user accounts.
- `user:accounts:delete`: Delete a user account.
- `user:accounts:me`: Treat the current account as self-managed profile/settings access.

- `user:roles:create`: Create a role.
- `user:roles:read`: View a single role.
- `user:roles:update`: Edit a role.
- `user:roles:list`: List and search roles.
- `user:roles:delete`: Delete a role.

- `user:invitations:create`: Create an invitation.
- `user:invitations:read`: View a single invitation.
- `user:invitations:update`: Edit an invitation.
- `user:invitations:list`: List and search invitations.
- `user:invitations:delete`: Delete an invitation.

## System

- `system:permissions:create`: Create a system permission entry.
- `system:permissions:read`: View a single system permission.
- `system:permissions:update`: Edit a system permission.
- `system:permissions:list`: List and search system permissions.
- `system:permissions:delete`: Delete a system permission.

- `system:variables:create`: Create a system variable.
- `system:variables:read`: View a single system variable.
- `system:variables:update`: Edit a system variable.
- `system:variables:list`: List and search system variables.
- `system:variables:delete`: Delete a system variable.

## Analytics

- `analytics:insights:list`: View analytics overview and insights dashboards.
- `analytics:logs:list`: List, search, and inspect raw analytics logs.

## Redirect

- `redirect:rules:create`: Create a redirect rule.
- `redirect:rules:read`: View a single redirect rule.
- `redirect:rules:update`: Edit a redirect rule.
- `redirect:rules:list`: List and search redirect rules.
- `redirect:rules:delete`: Delete a redirect rule.

- `redirect:not-found:list`: View 404 and missing-route reports.

## Blog

- `blog:posts:create`: Create a blog post.
- `blog:posts:read`: View a single blog post.
- `blog:posts:update`: Edit a blog post.
- `blog:posts:list`: List and search blog posts.
- `blog:posts:delete`: Delete a blog post.

- `blog:authors:create`: Create a blog author.
- `blog:authors:read`: View a single blog author.
- `blog:authors:update`: Edit a blog author.
- `blog:authors:list`: List and search blog authors.
- `blog:authors:delete`: Delete a blog author.

- `blog:tags:create`: Create a blog tag.
- `blog:tags:read`: View a single blog tag.
- `blog:tags:update`: Edit a blog tag.
- `blog:tags:list`: List and search blog tags.
- `blog:tags:delete`: Delete a blog tag.

- `blog:author-links:create`: Create an author link.
- `blog:author-links:read`: View a single author link.
- `blog:author-links:update`: Edit an author link.
- `blog:author-links:list`: List and search author links.
- `blog:author-links:delete`: Delete an author link.

- `blog:settings:read`: View blog settings.
- `blog:settings:update`: Edit blog settings.

## Web

- `web:pages:create`: Create a page.
- `web:pages:read`: View a single page.
- `web:pages:update`: Edit a page.
- `web:pages:list`: List and search pages.
- `web:pages:delete`: Delete a page.

- `web:metadata:create`: Create a web metadata entry.
- `web:metadata:read`: View a single web metadata entry.
- `web:metadata:update`: Edit a web metadata entry.
- `web:metadata:list`: List and search web metadata entries.
- `web:metadata:delete`: Delete a web metadata entry.

- `web:menus:create`: Create a menu.
- `web:menus:read`: View a single menu.
- `web:menus:update`: Edit a menu.
- `web:menus:list`: List and search menus.
- `web:menus:delete`: Delete a menu.

- `web:menu-items:create`: Create a menu item.
- `web:menu-items:read`: View a single menu item.
- `web:menu-items:update`: Edit a menu item.
- `web:menu-items:list`: List and search menu items.
- `web:menu-items:delete`: Delete a menu item.

- `web:settings:read`: View web settings.
- `web:settings:update`: Edit web settings.

## Media

- `media:assets:create`: Create or upload a media asset. Also covers media folder creation.
- `media:assets:read`: View a single media asset.
- `media:assets:update`: Edit a media asset. Also covers media folder editing.
- `media:assets:list`: List and search media assets. Also covers media folder browsing.
- `media:assets:delete`: Delete a media asset. Also covers media folder deletion.

- `media:processors:create`: Create a media processor.
- `media:processors:read`: View a single media processor.
- `media:processors:update`: Edit a media processor.
- `media:processors:list`: List and search media processors.
- `media:processors:delete`: Delete a media processor.

## Effective Permission Rules

- `user:accounts:me` grants effective access to:
  - `auth:profile:read`
  - `auth:profile:update`
  - `auth:settings:read`
  - `auth:settings:update`

- `auth:profile:update` also grants effective `auth:profile:read`.
- `auth:settings:update` also grants effective `auth:settings:read`.
- `blog:settings:update` also grants effective `blog:settings:read`.
- `web:settings:update` also grants effective `web:settings:read`.

## Review Notes

- `auth:admin:access` is the explicit gate for entering the admin dashboard and admin application shell.
- `root` is still treated as a backend superuser and bypasses granular permission checks in the authorizer.
- `user:accounts:me` is not a dead permission. The backend authorizer uses it to derive effective self-service profile and settings access.
- `auth:sessions:create` and `auth:sessions:update` are potential cleanup candidates. They are declared today, but the current server surface does not appear to expose admin routes that use them directly.
- `web:metadata:create` and `web:metadata:delete` are backend-only capabilities at the moment. The web-app no longer exposes metadata add/remove feature modules, but backend admin APIs still exist for create/delete operations.
- If metadata add/remove should be gone as a product capability, remove the related backend endpoints, use cases, and permissions too. If API-level management should remain available, keep these permissions.
