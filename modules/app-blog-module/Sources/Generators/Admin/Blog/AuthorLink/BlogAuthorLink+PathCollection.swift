import BlogSharedOpenAPIGenerator
import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension BlogAuthorLink {
    struct PathCollection: PathCollectionRepresentable {
        var pathMap: PathMap {
            [
                "api/v1/admin/blog/authors/{blogAuthorId}/links":
                    BlogAuthorLink.Menu.PathItem(),
                "api/v1/admin/blog/authors/{blogAuthorId}/links/":
                    BlogAuthorLink.List.PathItem(),
                "api/v1/admin/blog/authors/{blogAuthorId}/links/search":
                    BlogAuthorLink.Query.PathItem(),
                "api/v1/admin/blog/authors/{blogAuthorId}/links/{blogAuthorLinkId}":
                    BlogAuthorLink.ID.PathItem(),
            ]
        }
    }
}
