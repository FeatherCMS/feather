import FeatherOpenAPI
import FeatherOpenAPIGenerator
import OpenAPIKit30
import RedirectSharedOpenAPIGenerator

struct PathCollection: PathCollectionRepresentable {
    var pathMap: PathMap {
        [
            "api/v1/admin/redirect/rules": RedirectRulePathItems(),
            "api/v1/admin/redirect/rules/":
                RedirectRuleListPathItems(),
            "api/v1/admin/redirect/rules/search": RedirectRuleSearchPathItems(),
            "api/v1/admin/redirect/rules/{redirectRuleId}":
                RedirectRuleIdPathItems(),
        ]
    }
}
