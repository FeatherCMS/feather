import FeatherOpenAPI
import FeatherOpenAPIGenerator
import OpenAPIKit30

struct PathCollection: PathCollectionRepresentable {
    var pathMap: PathMap {
        [
            "api/v1/admin/redirect/rules": RedirectRulePathItems(),
            "api/v1/admin/redirect/rules/query": RedirectRuleQueryPathItems(),
            "api/v1/admin/redirect/rules/{redirectRuleId}":
                RedirectRuleIdPathItems(),
        ]
    }
}
