import AuthSharedOpenAPIGenerator
import FeatherOpenAPI
import OpenAPIKit30

struct PathCollection: PathCollectionRepresentable {
    var pathMap: PathMap {
        [
            "api/v1/admin/auth/me": AuthMePathItems(),
            "api/v1/admin/auth/login": AuthLoginPathItems(),
            "api/v1/admin/auth/logout": AuthLogoutPathItems(),
            "api/v1/admin/auth/magic-link": AuthMagicLinkPathItems(),
            "api/v1/admin/auth/magic-link/verify":
                AuthMagicLinkVerifyPathItems(),
            "api/v1/admin/user/identities/{userIdentityId}/sessions":
                UserIdentitySessionPathItems(),
            "api/v1/admin/user/identities/{userIdentityId}/sessions/{sessionId}":
                UserIdentitySessionIdPathItems(),
            "api/v1/admin/auth/credentials": AuthCredentialPathItems(),
            "api/v1/admin/auth/credentials/filters":
                AuthCredentialFiltersPathItems(),
            "api/v1/admin/auth/credentials/search":
                AuthCredentialSearchPathItems(),
            "api/v1/admin/auth/credentials/{authCredentialId}":
                AuthCredentialIdPathItems(),
            "api/v1/admin/auth/role-permissions": AuthRolePermissionPathItems(),
            "api/v1/admin/auth/role-permissions/search":
                AuthRolePermissionSearchPathItems(),
            "api/v1/admin/auth/role-permissions/{userRoleId}/{systemPermissionId}":
                AuthRolePermissionIdPathItems(),
            "api/v1/admin/auth/magic-links": AuthMagicLinkManagementPathItems(),
            "api/v1/admin/auth/magic-links/filters":
                AuthMagicLinkFiltersPathItems(),
            "api/v1/admin/auth/magic-links/search":
                AuthMagicLinkSearchPathItems(),
            "api/v1/admin/auth/magic-links/{authMagicLinkId}":
                AuthMagicLinkIdPathItems(),
        ]
    }
}
