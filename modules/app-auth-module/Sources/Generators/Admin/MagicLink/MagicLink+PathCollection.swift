import FeatherOpenAPI

enum MagicLink {}

extension MagicLink {
    struct PathCollection: PathCollectionRepresentable {
        var pathMap: PathMap {
            [
                "api/v1/admin/auth/magic-links":
                    AuthMagicLinkManagementPathItems(),
                "api/v1/admin/auth/magic-links/query":
                    AuthMagicLinkQueryPathItems(),
                "api/v1/admin/auth/magic-links/{authMagicLinkId}":
                    AuthMagicLinkIdPathItems(),
            ]
        }
    }
}
