import FeatherOpenAPI
import FeatherOpenAPIGenerator
import OpenAPIKit30

extension Variable {
    struct PathCollection: PathCollectionRepresentable {
        var pathMap: PathMap {
            [
                "api/v1/admin/system/variables": PathItem(),
                "api/v1/admin/system/variables/query": Query.PathItem(),
                "api/v1/admin/system/variables/{systemVariableId}":
                    Get.PathItem(),
            ]
        }
    }
}
