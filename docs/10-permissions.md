# Backend permissions

This reference lists the permission keys declared by Feather's module source. A permission key is a stable string used by application authorization and Admin UI visibility.

## Account

- `account:profile:create` Create a profile.
- `account:profile:read` View a profile.
- `account:profile:update` Edit a profile.
- `account:settings:read` View account settings.
- `account:settings:update` Edit account settings.
- `account:invitations:create` Create an invitation.
- `account:invitations:read` View an invitation.
- `account:invitations:update` Edit an invitation.
- `account:invitations:list` List and search invitations.
- `account:invitations:delete` Delete an invitation.

## Analytics

- `analytics:insights:list` View analytics insights.
- `analytics:logs:list` List and search analytics logs.
- `analytics:not-found:list` View not-found request reports.

## Auth

- `auth:credential:create` Create credentials.
- `auth:credential:read` View credentials.
- `auth:credential:update` Update credentials.
- `auth:credential:list` List credentials.
- `auth:credential:find` Find credentials by email or ID.
- `auth:credential:delete` Delete credentials.
- `auth:email:create` Create an email address.
- `auth:email:read` View an email address.
- `auth:email:update` Update an email address.
- `auth:email:list` List email addresses.
- `auth:email:delete` Delete an email address.
- `auth:magic-links:create` Create a magic link.
- `auth:magic-links:read` View a magic link.
- `auth:magic-links:update` Update a magic link.
- `auth:magic-links:list` List magic links.
- `auth:magic-links:delete` Delete a magic link.
- `auth:sessions:create` Create a session.
- `auth:sessions:read` View a session.
- `auth:sessions:update` Extend or update a session.
- `auth:sessions:list` List sessions.
- `auth:sessions:delete` Delete a session.
- `auth:access-control:create` Assign a permission to a role.
- `auth:access-control:read` View a role-permission assignment.
- `auth:access-control:update` Update role-permission assignments.
- `auth:access-control:list` List role-permission assignments.
- `auth:access-control:delete` Remove a permission from a role.

## Blog

- `blog:posts:create` Create a post.
- `blog:posts:read` View a post.
- `blog:posts:update` Edit a post.
- `blog:posts:list` List and search posts.
- `blog:posts:delete` Delete a post.
- `blog:authors:create` Create an author.
- `blog:authors:read` View an author.
- `blog:authors:update` Edit an author.
- `blog:authors:list` List and search authors.
- `blog:authors:delete` Delete an author.
- `blog:author-links:create` Create an author link.
- `blog:author-links:read` View an author link.
- `blog:author-links:update` Edit an author link.
- `blog:author-links:list` List author links.
- `blog:author-links:delete` Delete an author link.
- `blog:tags:create` Create a tag.
- `blog:tags:read` View a tag.
- `blog:tags:update` Edit a tag.
- `blog:tags:list` List and search tags.
- `blog:tags:delete` Delete a tag.
- `blog:settings:read` View blog settings.
- `blog:settings:update` Edit blog settings.

## Contact

- `contact:forms:create` Create a form.
- `contact:forms:read` View a form.
- `contact:forms:update` Edit a form.
- `contact:forms:list` List and search forms.
- `contact:forms:delete` Delete a form.
- `contact:form-fields:create` Create a form field.
- `contact:form-fields:read` View a form field.
- `contact:form-fields:update` Edit a form field.
- `contact:form-fields:list` List form fields.
- `contact:form-fields:delete` Delete a form field.
- `contact:form-submissions:read` View a form submission.
- `contact:form-submissions:update` Update a form submission.
- `contact:form-submissions:list` List form submissions.
- `contact:form-submissions:delete` Delete a form submission.
- `contact:form-mails:create` Create a form mail configuration.
- `contact:form-mails:read` View a form mail configuration.
- `contact:form-mails:update` Edit a form mail configuration.
- `contact:form-mails:list` List form mail configurations.
- `contact:form-mails:delete` Delete a form mail configuration.

## Media

- `media:assets:create` Upload a media asset; also covers media folder creation. Also covers media folder creation.
- `media:assets:read` View a media asset.
- `media:assets:update` Edit a media asset; also covers media folder editing.
- `media:assets:list` List and search assets; also covers media folder browsing.
- `media:assets:delete` Delete an asset; also covers media folder deletion.
- `media:variants:create` Create a media variant.
- `media:variants:read` View a media variant.
- `media:variants:update` Edit a media variant.
- `media:variants:list` List media variants.
- `media:variants:delete` Delete a media variant.
- `media:variant-processors:create` Add a processor rule to a variant.
- `media:variant-processors:read` View a variant processor rule.
- `media:variant-processors:update` Edit a variant processor rule.
- `media:variant-processors:list` List variant processor rules.
- `media:variant-processors:delete` Delete a variant processor rule.

## News

- `news:article:create` Create an article.
- `news:article:read` View an article.
- `news:article:update` Edit an article.
- `news:article:list` List and search articles.
- `news:article:delete` Delete an article.
- `news:category:create` Create a category.
- `news:category:read` View a category.
- `news:category:update` Edit a category.
- `news:category:list` List and search categories.
- `news:category:delete` Delete a category.

## Newsletter

- `newsletter:campaigns:create` Create a campaign.
- `newsletter:campaigns:read` View a campaign.
- `newsletter:campaigns:update` Edit a campaign.
- `newsletter:campaigns:list` List and search campaigns.
- `newsletter:campaigns:delete` Delete a campaign.
- `newsletter:issues:create` Create an issue.
- `newsletter:issues:read` View an issue.
- `newsletter:issues:update` Edit an issue.
- `newsletter:issues:list` List and search issues.
- `newsletter:issues:delete` Delete an issue.
- `newsletter:subscribers:create` Create a subscriber.
- `newsletter:subscribers:read` View a subscriber.
- `newsletter:subscribers:update` Edit a subscriber.
- `newsletter:subscribers:list` List and search subscribers.
- `newsletter:subscribers:delete` Delete a subscriber.

## Redirect

- `redirect:rules:create` Create a redirect rule.
- `redirect:rules:read` View a redirect rule.
- `redirect:rules:update` Edit a redirect rule.
- `redirect:rules:list` List redirect rules.
- `redirect:rules:search` Search redirect rules.
- `redirect:rules:delete` Delete a redirect rule.
- `redirect:not-found:list` View not-found request reports.

## System

- `system:admin:access` Enter the Admin application.
- `system:permissions:create` Create a system permission entry.
- `system:permissions:read` View a system permission.
- `system:permissions:update` Edit a system permission.
- `system:permissions:list` List and search system permissions.
- `system:permissions:delete` Delete a system permission.
- `system:variables:create` Create a system variable.
- `system:variables:read` View a system variable.
- `system:variables:update` Edit a system variable.
- `system:variables:list` List and search system variables.
- `system:variables:delete` Delete a system variable.
- `system:jobs:read` View a background job.
- `system:jobs:list` List and search background jobs.

## User

- `user:identities:create` Create an identity.
- `user:identities:read` View an identity.
- `user:identities:update` Edit an identity.
- `user:identities:list` List and search identities.
- `user:identities:delete` Delete an identity.
- `user:identities:me` Perform self-service identity operations.
- `user:roles:create` Create a role.
- `user:roles:read` View a role.
- `user:roles:update` Edit a role.
- `user:roles:list` List and search roles.
- `user:roles:delete` Delete a role.

## Web

- `web:metadata:access` Access web metadata administration.
- `web:pages:create` Create a page.
- `web:pages:read` View a page.
- `web:pages:update` Edit a page.
- `web:pages:list` List and search pages.
- `web:pages:delete` Delete a page.
- `web:menus:create` Create a menu.
- `web:menus:read` View a menu.
- `web:menus:update` Edit a menu.
- `web:menus:list` List and search menus.
- `web:menus:delete` Delete a menu.
- `web:menu-items:create` Create a menu item.
- `web:menu-items:read` View a menu item.
- `web:menu-items:update` Edit a menu item.
- `web:menu-items:list` List and search menu items.
- `web:menu-items:delete` Delete a menu item.
- `web:settings:read` View web settings.
- `web:settings:update` Edit web settings.

## Authorization notes

- The Admin shell checks `system:admin:access`.
- The Auth permission query treats a root identity as having all stored permission keys.

Permission keys are declared by their owning module. Check that module's source before changing or assigning a key.
