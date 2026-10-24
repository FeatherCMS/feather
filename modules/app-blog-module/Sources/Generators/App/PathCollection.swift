import BlogSchemaSupport
import FeatherOpenAPI
import FeatherOpenAPIGenerator

struct PathCollection: PathCollectionRepresentable {

    var pathMap: PathMap {
        var paths: PathMap = [:]
        paths.merge(Author.PathCollection().pathMap) { current, _ in current
        }
        paths.merge(Post.PathCollection().pathMap) { current, _ in current }
        paths.merge(Settings.PathCollection().pathMap) { current, _ in
            current
        }
        paths.merge(Tag.PathCollection().pathMap) { current, _ in current }
        return paths
    }
}
