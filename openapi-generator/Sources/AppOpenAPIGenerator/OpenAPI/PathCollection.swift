//
//  File.swift
//  openapi-generator
//
//  Created by Tibor Bödecs on 2026. 03. 19..
//

import FeatherOpenAPI
import OpenAPIKit30
import SharedOpenAPIComponents

struct PathCollection: PathCollectionRepresentable {

    var pathMap: PathMap {
        [
            "api/v1/analytics/logs/track": AnalyticsLogTrackPathItems(),
            "api/v1/blog/settings": BlogRouteSettingsPathItems(),
            "api/v1/web/settings": WebSiteSettingsPathItems(),
            "api/v1/web/menus": WebMenuListPathItems(),
            "api/v1/web/routes/{slug}": WebMetadataGetPathItems(),
            "api/v1/blog/posts": BlogPostListPathItems(),
            "api/v1/blog/posts/{id}": BlogPostGetPathItems(),
            "api/v1/blog/authors": BlogAuthorListPathItems(),
            "api/v1/blog/authors/{id}": BlogAuthorGetPathItems(),
            "api/v1/blog/tags": BlogTagListPathItems(),
            "api/v1/blog/tags/{id}": BlogTagGetPathItems(),
            "api/v1/redirect/rules": RedirectRuleGetPathItems(),
            "api/v1/web/pages/{id}": WebPageGetPathItems(),
            "api/v1/auth/me": AuthMePathItems(),
            "api/v1/auth/register": AuthRegisterPathItems(),
            "api/v1/auth/login": AuthLoginPathItems(),
            "api/v1/auth/logout": AuthLogoutPathItems(),
            "api/v1/auth/magic-link": AuthMagicLinkPathItems(),
            "api/v1/auth/magic-link/verify": AuthMagicLinkVerifyPathItems(),
        ]
    }
}
