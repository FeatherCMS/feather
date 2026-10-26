import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension Article {
    struct PathCollection: PathCollectionRepresentable {
        var pathMap: PathMap {
            [
                "api/v1/news/articles": PathItem(),
                "api/v1/news/articles/{id}": ID.PathItem(),
            ]
        }
    }
}
