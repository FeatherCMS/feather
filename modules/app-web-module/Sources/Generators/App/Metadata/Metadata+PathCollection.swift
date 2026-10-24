public import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension Metadata {
    struct PathCollection: PathCollectionRepresentable {
        var pathMap: PathMap {
            [
                "api/v1/web/routes": Root.PathItem(),
                "api/v1/web/routes/{slug}": Slug.PathItem(),
                "api/v1/web/metadata": PathItem(),
            ]
        }
    }
}
