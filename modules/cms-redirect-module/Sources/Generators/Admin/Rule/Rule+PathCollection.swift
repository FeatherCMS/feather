import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension Rule {
    struct PathCollection: PathCollectionRepresentable {
        var pathMap: PathMap {
            [
                "api/v1/admin/redirect/rules": PathItem(),
                "api/v1/admin/redirect/rules/query": Query.PathItem(),
                "api/v1/admin/redirect/rules/{redirectRuleId}": ID.PathItem(),
            ]
        }
    }
}
