import FeatherOpenAPI

enum MagicLink {}

extension MagicLink {
    struct PathCollection: PathCollectionRepresentable {
        var pathMap: PathMap {
            [
                "api/v1/admin/auth/magic-links":
                    AuthMagicLinkManagementPathItems(),
                "api/v1/admin/auth/magic-links/": AuthMagicLinkListPathItems(),
                "api/v1/admin/auth/magic-links/search":
                    AuthMagicLinkSearchPathItems(),
                "api/v1/admin/auth/magic-links/{authMagicLinkId}":
                    AuthMagicLinkIdPathItems(),
            ]
        }
    }
}
