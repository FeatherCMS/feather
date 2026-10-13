import BlogSharedOpenAPIGenerator
import FeatherOpenAPI
import FeatherOpenAPIGenerator
import OpenAPIKit30

struct PathCollection: PathCollectionRepresentable {

    var pathMap: PathMap {
        [
            "api/v1/admin/blog/posts": BlogPostPathItems(),
            "api/v1/admin/blog/posts/": BlogPostListPathItems(),
            "api/v1/admin/blog/posts/search": BlogPostSearchPathItems(),
            "api/v1/admin/blog/posts/{blogPostId}": BlogPostIdPathItems(),
            "api/v1/admin/blog/authors": BlogAuthorPathItems(),
            "api/v1/admin/blog/authors/": BlogAuthorListPathItems(),
            "api/v1/admin/blog/authors/search": BlogAuthorSearchPathItems(),
            "api/v1/admin/blog/authors/{blogAuthorId}": BlogAuthorIdPathItems(),
            "api/v1/admin/blog/authors/{blogAuthorId}/links":
                BlogAuthorLinkPathItems(),
            "api/v1/admin/blog/authors/{blogAuthorId}/links/":
                BlogAuthorLinkListPathItems(),
            "api/v1/admin/blog/authors/{blogAuthorId}/links/search":
                BlogAuthorLinkSearchPathItems(),
            "api/v1/admin/blog/authors/{blogAuthorId}/links/{blogAuthorLinkId}":
                BlogAuthorLinkIdPathItems(),
            "api/v1/admin/blog/settings": BlogSettingsPathItems(),
            "api/v1/admin/blog/tags": BlogTagPathItems(),
            "api/v1/admin/blog/tags/": BlogTagListPathItems(),
            "api/v1/admin/blog/tags/search": BlogTagSearchPathItems(),
            "api/v1/admin/blog/tags/{blogTagId}": BlogTagIdPathItems(),
        ]
    }
}
