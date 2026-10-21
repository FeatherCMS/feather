import AuthSharedOpenAPIGenerator
import FeatherOpenAPI

enum Auth {}

extension Auth {
    struct PathCollection: PathCollectionRepresentable {
        var pathMap: PathMap {
            [
                "api/v1/admin/auth/me": AuthMePathItems(),
                "api/v1/admin/auth/login": AuthLoginPathItems(),
                "api/v1/admin/auth/logout": AuthLogoutPathItems(),
                "api/v1/admin/auth/magic-link": AuthMagicLinkPathItems(),
                "api/v1/admin/auth/magic-link/verify":
                    AuthMagicLinkVerifyPathItems(),
            ]
        }
    }
}
