import BlogSharedOpenAPIGenerator
import FeatherOpenAPI
import FeatherOpenAPIGenerator

struct PathCollection: PathCollectionRepresentable {

    var pathMap: PathMap {
        var paths: PathMap = [:]
        paths.merge(BlogAuthor.PathCollection().pathMap) { current, _ in current
        }
        paths.merge(BlogAuthorLink.PathCollection().pathMap) { current, _ in
            current
        }
        paths.merge(BlogPost.PathCollection().pathMap) { current, _ in current }
        paths.merge(BlogSettings.PathCollection().pathMap) { current, _ in
            current
        }
        paths.merge(BlogTag.PathCollection().pathMap) { current, _ in current }
        return paths
    }
}
