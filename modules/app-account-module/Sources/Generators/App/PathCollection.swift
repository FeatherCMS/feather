import FeatherOpenAPI
import FeatherOpenAPIGenerator
import OpenAPIKit30

struct PathCollection: PathCollectionRepresentable {
    var pathMap: PathMap {
        var paths: PathMap = [:]
        paths.merge(Account.PathCollection().pathMap) { current, _ in current }
        paths.merge(Invitation.PathCollection().pathMap) {
            current,
            _ in current
        }
        paths.merge(Settings.PathCollection().pathMap) { current, _ in current }
        paths.merge(Profile.PathCollection().pathMap) {
            current,
            _ in current
        }
        return paths
    }
}
