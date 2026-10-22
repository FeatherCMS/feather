import BlogSharedOpenAPIGenerator
import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension BlogAuthor {
    struct PathCollection: PathCollectionRepresentable {
        var pathMap: PathMap {
            [
                "api/v1/admin/blog/authors": BlogAuthor.PathItem(),
                "api/v1/admin/blog/authors/": BlogAuthor.List.PathItem(),
                "api/v1/admin/blog/authors/search": BlogAuthor.Query.PathItem(),
                "api/v1/admin/blog/authors/{blogAuthorId}":
                    BlogAuthor.ID.PathItem(),
            ]
        }
    }
}
