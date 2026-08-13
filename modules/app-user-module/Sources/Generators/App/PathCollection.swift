import FeatherOpenAPI
import FeatherOpenAPIGenerator
import OpenAPIKit30
import UserSharedOpenAPIGenerator

struct PathCollection: PathCollectionRepresentable {
    var pathMap: PathMap {
        [:]
    }
}
