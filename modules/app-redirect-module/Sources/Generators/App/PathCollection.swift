import FeatherOpenAPI
import FeatherOpenAPIGenerator
import OpenAPIKit30
import RedirectSharedOpenAPIGenerator

struct PathCollection: PathCollectionRepresentable {
    var pathMap: PathMap {
        [
            "api/v1/redirect/rules": RedirectRuleGetPathItems()
        ]
    }
}
