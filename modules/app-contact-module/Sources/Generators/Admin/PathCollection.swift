import FeatherOpenAPI
import FeatherOpenAPIGenerator
import OpenAPIKit30

struct PathCollection: PathCollectionRepresentable {

    var pathMap: PathMap {
        var paths: PathMap = [:]
        paths.merge(Contact.Form.PathCollection().pathMap) { current, _ in
            current
        }
        paths.merge(Contact.Field.PathCollection().pathMap) { current, _ in
            current
        }
        paths.merge(Contact.Submission.PathCollection().pathMap) {
            current, _ in current
        }
        return paths
    }
}
