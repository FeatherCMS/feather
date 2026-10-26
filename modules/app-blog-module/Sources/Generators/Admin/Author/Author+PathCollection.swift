import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension Author {
    struct PathCollection: PathCollectionRepresentable {
        var pathMap: PathMap {
            [
                "api/v1/admin/blog/authors": PathItem(),
                "api/v1/admin/blog/authors/query": Query.PathItem(),
                "api/v1/admin/blog/authors/{blogAuthorId}":
                    ID.PathItem(),
            ]
        }
    }
}
