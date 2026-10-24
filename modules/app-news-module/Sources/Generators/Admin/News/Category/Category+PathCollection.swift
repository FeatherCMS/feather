import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension Category {
    struct PathCollection: PathCollectionRepresentable {
        var pathMap: PathMap {
            [
                "api/v1/admin/news/categories": PathItem(),
                "api/v1/admin/news/categories/": List.PathItem(),
                "api/v1/admin/news/categories/query": Query.PathItem(),
                "api/v1/admin/news/categories/{newsCategoryId}": ID.PathItem(),
            ]
        }
    }
}
