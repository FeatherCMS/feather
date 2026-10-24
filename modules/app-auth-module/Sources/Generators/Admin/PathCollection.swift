import FeatherOpenAPI
import OpenAPIKit30

struct PathCollection: PathCollectionRepresentable {
    var pathMap: PathMap {
        var paths: PathMap = [:]
        paths.merge(Identity.PathCollection().pathMap) { current, _ in current }
        paths.merge(Credential.PathCollection().pathMap) { current, _ in current
        }
        paths.merge(Email.PathCollection().pathMap) { current, _ in current
        }
        paths.merge(RolePermission.PathCollection().pathMap) { current, _ in
            current
        }
        paths.merge(MagicLink.PathCollection().pathMap) { current, _ in current
        }
        return paths
    }
}
