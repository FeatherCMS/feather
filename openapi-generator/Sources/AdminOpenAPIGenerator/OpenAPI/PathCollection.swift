//
//  File.swift
//  openapi-generator
//
//  Created by Tibor Bödecs on 2026. 03. 10..
//

import FeatherOpenAPI
import OpenAPIKit30
import SharedOpenAPIComponents

struct PathCollection: PathCollectionRepresentable {

    var pathMap: PathMap {
        [
            "api/v1/admin/user/auth/me": AuthMePathItems(),
            "api/v1/admin/user/auth/login": AuthLoginPathItems(),
            "api/v1/admin/user/auth/logout": AuthLogoutPathItems(),
            "api/v1/admin/user/auth/magic-link": AuthMagicLinkPathItems(),
            "api/v1/admin/user/auth/magic-link/verify":
                AuthMagicLinkVerifyPathItems(),

            "api/v1/admin/user/accounts": UserAccountPathItems(),
            "api/v1/admin/user/accounts/filters": UserAccountFiltersPathItems(),
            "api/v1/admin/user/accounts/search": UserAccountSearchPathItems(),
            "api/v1/admin/user/accounts/{userAccountId}":
                UserAccountIdPathItems(),
            "api/v1/admin/user/accounts/{userAccountId}/sessions":
                UserAccountSessionPathItems(),
            "api/v1/admin/user/accounts/{userAccountId}/sessions/{sessionId}":
                UserAccountSessionIdPathItems(),

            "api/v1/admin/user/roles": UserRolePathItems(),
            "api/v1/admin/user/roles/filters": UserRoleFiltersPathItems(),
            "api/v1/admin/user/roles/search": UserRoleSearchPathItems(),
            "api/v1/admin/user/roles/{userRoleId}": UserRoleIdPathItems(),
            "api/v1/admin/user/role-permissions": UserRolePermissionPathItems(),
            "api/v1/admin/user/role-permissions/search":
                UserRolePermissionSearchPathItems(),
            "api/v1/admin/user/role-permissions/{userRoleId}/{systemPermissionId}":
                UserRolePermissionIdPathItems(),

            "api/v1/admin/user/invitations": UserInvitationPathItems(),
            "api/v1/admin/user/invitations/filters":
                UserInvitationFiltersPathItems(),
            "api/v1/admin/user/invitations/search":
                UserInvitationSearchPathItems(),
            "api/v1/admin/user/invitations/{userInvitationId}":
                UserInvitationIdPathItems(),

            "api/v1/admin/user/magic-links": UserMagicLinkPathItems(),
            "api/v1/admin/user/magic-links/filters":
                UserMagicLinkFiltersPathItems(),
            "api/v1/admin/user/magic-links/search":
                UserMagicLinkSearchPathItems(),
            "api/v1/admin/user/magic-links/{userMagicLinkId}":
                UserMagicLinkIdPathItems(),

            "api/v1/admin/system/permissions": SystemPermissionPathItems(),
            "api/v1/admin/system/permissions/filters":
                SystemPermissionFiltersPathItems(),
            "api/v1/admin/system/permissions/search":
                SystemPermissionSearchPathItems(),
            "api/v1/admin/system/permissions/{systemPermissionId}":
                SystemPermissionIdPathItems(),

            "api/v1/admin/system/variables": SystemVariablePathItems(),
            "api/v1/admin/system/variables/filters":
                SystemVariableFiltersPathItems(),
            "api/v1/admin/system/variables/search":
                SystemVariableSearchPathItems(),
            "api/v1/admin/system/variables/{systemVariableId}":
                SystemVariableIdPathItems(),

            "api/v1/admin/analytics/logs/filters":
                AnalyticsLogFiltersPathItems(),
            "api/v1/admin/analytics/logs/overview":
                AnalyticsLogOverviewPathItems(),
            "api/v1/admin/analytics/logs/search": AnalyticsLogSearchPathItems(),
            "api/v1/admin/analytics/logs/{id}": AnalyticsLogIdPathItems(),

            "api/v1/admin/web/metadata": WebMetadataPathItems(),
            "api/v1/admin/web/metadata/filters": WebMetadataFiltersPathItems(),
            "api/v1/admin/web/metadata/search": WebMetadataSearchPathItems(),
            "api/v1/admin/web/metadata/{webMetadataId}":
                WebMetadataIdPathItems(),

            "api/v1/admin/redirect/rules": RedirectRulePathItems(),
            "api/v1/admin/redirect/rules/filters":
                RedirectRuleFiltersPathItems(),
            "api/v1/admin/redirect/not-found/overview":
                RedirectNotFoundOverviewPathItems(),
            "api/v1/admin/redirect/rules/search": RedirectRuleSearchPathItems(),
            "api/v1/admin/redirect/rules/{redirectRuleId}":
                RedirectRuleIdPathItems(),

            "api/v1/admin/blog/posts": BlogPostPathItems(),
            "api/v1/admin/blog/posts/filters": BlogPostFiltersPathItems(),
            "api/v1/admin/blog/posts/search": BlogPostSearchPathItems(),
            "api/v1/admin/blog/posts/{blogPostId}": BlogPostIdPathItems(),
            "api/v1/admin/blog/authors": BlogAuthorPathItems(),
            "api/v1/admin/blog/authors/filters": BlogAuthorFiltersPathItems(),
            "api/v1/admin/blog/authors/search": BlogAuthorSearchPathItems(),
            "api/v1/admin/blog/authors/{blogAuthorId}": BlogAuthorIdPathItems(),
            "api/v1/admin/blog/authors/{blogAuthorId}/links":
                BlogAuthorLinkPathItems(),
            "api/v1/admin/blog/authors/{blogAuthorId}/links/filters":
                BlogAuthorLinkFiltersPathItems(),
            "api/v1/admin/blog/authors/{blogAuthorId}/links/search":
                BlogAuthorLinkSearchPathItems(),
            "api/v1/admin/blog/authors/{blogAuthorId}/links/{blogAuthorLinkId}":
                BlogAuthorLinkIdPathItems(),
            "api/v1/admin/blog/settings": BlogSettingsPathItems(),
            "api/v1/admin/blog/tags": BlogTagPathItems(),
            "api/v1/admin/blog/tags/filters": BlogTagFiltersPathItems(),
            "api/v1/admin/blog/tags/search": BlogTagSearchPathItems(),
            "api/v1/admin/blog/tags/{blogTagId}": BlogTagIdPathItems(),

            "api/v1/admin/web/pages": WebPagePathItems(),
            "api/v1/admin/web/pages/filters": WebPageFiltersPathItems(),
            "api/v1/admin/web/pages/search": WebPageSearchPathItems(),
            "api/v1/admin/web/pages/{webPageId}": WebPageIdPathItems(),
            "api/v1/admin/web/menus": WebMenuPathItems(),
            "api/v1/admin/web/menus/filters": WebMenuFiltersPathItems(),
            "api/v1/admin/web/menus/search": WebMenuSearchPathItems(),
            "api/v1/admin/web/menus/{webMenuId}": WebMenuIdPathItems(),
            "api/v1/admin/web/menus/{webMenuId}/items": WebMenuItemPathItems(),
            "api/v1/admin/web/menus/{webMenuId}/items/filters":
                WebMenuItemFiltersPathItems(),
            "api/v1/admin/web/menus/{webMenuId}/items/search":
                WebMenuItemSearchPathItems(),
            "api/v1/admin/web/menus/{webMenuId}/items/{webMenuItemId}":
                WebMenuItemIdPathItems(),
            "api/v1/admin/web/settings": WebSettingsPathItems(),

            "api/v1/admin/media/assets": MediaAssetPathItems(),
            "api/v1/admin/media/assets/search": MediaAssetSearchPathItems(),
            "api/v1/admin/media/assets/{mediaAssetId}": MediaAssetIdPathItems(),
            "api/v1/admin/media/assets/{mediaAssetId}/variants":
                MediaAssetVariantPathItems(),
            "api/v1/admin/media/folders": MediaFolderPathItems(),
            "api/v1/admin/media/folders/search": MediaFolderSearchPathItems(),
            "api/v1/admin/media/folders/{mediaFolderId}":
                MediaFolderIdPathItems(),

            "api/v1/admin/media/processors": MediaProcessorPathItems(),
            "api/v1/admin/media/processors/search":
                MediaProcessorSearchPathItems(),
            "api/v1/admin/media/processors/{mediaProcessorId}":
                MediaProcessorIdPathItems(),

                //            "v1/management/user/accounts": UserAccountPathItems(),
                //            "v1/management/user/accounts/search": CollectionSearchPathItems(
                //                tags: [UserAccountTag()],
                //                operationId: "searchUserAccounts"
                //            ),
                //            "v1/management/user/accounts/delete": CollectionDeletePathItems(
                //                tags: [UserAccountTag()],
                //                operationId: "deleteUserAccounts"
                //            ),
                //            "v1/management/user/accounts/{userAccountId}": UserAccountIdPathItems(),

                //            "v1/management/user/roles": UserRolePathItems(),
                //            "v1/management/user/roles/search": CollectionSearchPathItems(
                //                tags: [UserRoleTag()],
                //                operationId: "searchUserRoles"
                //            ),
                //            "v1/management/user/roles/delete": CollectionDeletePathItems(
                //                tags: [UserRoleTag()],
                //                operationId: "deleteUserRoles"
                //            ),
                //            "v1/management/user/roles/{userRoleId}": UserRoleIdPathItems(),
                //            "v1/management/user/invitations": UserInvitationPathItems(),
                //            "v1/management/user/invitations/search": CollectionSearchPathItems(
                //                tags: [UserInvitationTag()],
                //                operationId: "searchUserInvitations"
                //            ),
                //            "v1/management/user/invitations/delete": CollectionDeletePathItems(
                //                tags: [UserInvitationTag()],
                //                operationId: "deleteUserInvitations"
                //            ),
                //            "v1/management/user/invitations/{userInvitationId}": UserInvitationIdPathItems(),
                //            "v1/management/user/magic-links": UserMagicLinkPathItems(),
                //            "v1/management/user/magic-links/search": CollectionSearchPathItems(
                //                tags: [UserMagicLinkTag()],
                //                operationId: "searchUserMagicLinks"
                //            ),
                //            "v1/management/user/magic-links/delete": CollectionDeletePathItems(
                //                tags: [UserMagicLinkTag()],
                //                operationId: "deleteUserMagicLinks"
                //            ),
                //            "v1/management/user/magic-links/{userMagicLinkId}": UserMagicLinkIdPathItems(),
                //            "v1/management/system/permissions": SystemPermissionPathItems(),
                //            "v1/management/system/permissions/search": CollectionSearchPathItems(
                //                tags: [SystemPermissionTag()],
                //                operationId: "searchSystemPermissions"
                //            ),
                //            "v1/management/system/permissions/delete": CollectionDeletePathItems(
                //                tags: [SystemPermissionTag()],
                //                operationId: "deleteSystemPermissions"
                //            ),
                //            "v1/management/system/permissions/{systemPermissionId}": SystemPermissionIdPathItems(),
                //            "v1/management/system/variables": SystemVariablePathItems(),
                //            "v1/management/system/variables/search": CollectionSearchPathItems(
                //                tags: [SystemVariableTag()],
                //                operationId: "searchSystemVariables"
                //            ),
                //            "v1/management/system/variables/delete": CollectionDeletePathItems(
                //                tags: [SystemVariableTag()],
                //                operationId: "deleteSystemVariables"
                //            ),
                //            "v1/management/system/variables/{systemVariableId}": SystemVariableIdPathItems(),
        ]
    }
}
