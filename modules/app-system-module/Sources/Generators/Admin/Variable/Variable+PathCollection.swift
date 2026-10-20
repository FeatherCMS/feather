import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension Variable {
    struct PathCollection: PathCollectionRepresentable {
        var pathMap: PathMap {
            [
                "api/v1/admin/system/variables": PathItem(),
                "api/v1/admin/system/variables/query": Query.PathItem(),
                "api/v1/admin/system/variables/{systemVariableId}":
                    ID.PathItem(),
            ]
        }
    }
}
