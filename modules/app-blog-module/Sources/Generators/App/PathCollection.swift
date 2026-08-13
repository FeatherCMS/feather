import BlogSharedOpenAPIGenerator
import FeatherOpenAPI
import FeatherOpenAPIGenerator
import OpenAPIKit30

struct PathCollection: PathCollectionRepresentable {

    var pathMap: PathMap {
        [
            "api/v1/blog/settings": BlogRouteSettingsPathItems(),
            "api/v1/blog/posts": BlogPostListPathItems(),
            "api/v1/blog/posts/{id}": BlogPostGetPathItems(),
            "api/v1/blog/authors": BlogAuthorListPathItems(),
            "api/v1/blog/authors/{id}": BlogAuthorGetPathItems(),
            "api/v1/blog/tags": BlogTagListPathItems(),
            "api/v1/blog/tags/{id}": BlogTagGetPathItems(),
        ]
    }
}
