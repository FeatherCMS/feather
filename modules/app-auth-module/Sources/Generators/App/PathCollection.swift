import FeatherOpenAPI
import OpenAPIKit30

struct PathCollection: PathCollectionRepresentable {
    var pathMap: PathMap {
        Auth.PathCollection().pathMap
    }
}

extension Auth {
    struct PathCollection: PathCollectionRepresentable {
        var pathMap: PathMap {
            [
                "api/v1/auth/me": Me.PathItem(),
                "api/v1/auth/login": Login.PathItem(),
                "api/v1/auth/logout": Logout.PathItem(),
                "api/v1/auth/magic-link": MagicLink.PathItem(),
                "api/v1/auth/magic-link/verify": MagicLink.Verify.PathItem(),
            ]
        }
    }
}
