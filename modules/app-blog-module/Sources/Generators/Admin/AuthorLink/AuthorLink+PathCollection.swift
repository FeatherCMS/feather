import BlogSchemaSupport
import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension AuthorLink {
    struct PathCollection: PathCollectionRepresentable {
        var pathMap: PathMap {
            [
                "api/v1/admin/blog/authors/{blogAuthorId}/links":
                    PathItem(),
                "api/v1/admin/blog/authors/{blogAuthorId}/links/query":
                    Query.PathItem(),
                "api/v1/admin/blog/authors/{blogAuthorId}/links/{blogAuthorLinkId}":
                    ID.PathItem(),
            ]
        }
    }
}
