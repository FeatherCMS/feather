import AuthSharedOpenAPIGenerator
import FeatherOpenAPI
import OpenAPIKit30

enum Auth {}

struct PathCollection: PathCollectionRepresentable {
    var pathMap: PathMap {
        Auth.PathCollection().pathMap
    }
}

extension Auth {
    struct PathCollection: PathCollectionRepresentable {
        var pathMap: PathMap {
            [
                "api/v1/auth/me": AuthMePathItems(),
                "api/v1/auth/login": AuthLoginPathItems(),
                "api/v1/auth/logout": AuthLogoutPathItems(),
                "api/v1/auth/magic-link": AuthMagicLinkPathItems(),
                "api/v1/auth/magic-link/verify": AuthMagicLinkVerifyPathItems(),
            ]
        }
    }
}
