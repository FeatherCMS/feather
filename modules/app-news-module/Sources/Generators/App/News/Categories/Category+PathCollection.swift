import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension Category {
    struct PathCollection: PathCollectionRepresentable {
        var pathMap: PathMap {
            [
                "api/v1/news/categories": PathItem(),
                "api/v1/news/categories/{id}": ID.PathItem(),
            ]
        }
    }
}
