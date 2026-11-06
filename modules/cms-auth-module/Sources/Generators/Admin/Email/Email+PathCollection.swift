import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension Email {
    struct PathCollection: PathCollectionRepresentable {
        var pathMap: PathMap {
            [
                "api/v1/admin/auth/emails": PathItem(),
                "api/v1/admin/auth/emails/query": Query.PathItem(),
                "api/v1/admin/auth/emails/{authEmailId}": ID.PathItem(),
            ]
        }
    }
}
