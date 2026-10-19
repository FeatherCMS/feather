import FeatherOpenAPI
import FeatherOpenAPIGenerator
import OpenAPIKit30

extension Permission {
    struct PathCollection: PathCollectionRepresentable {
        var pathMap: PathMap {
            [
                "api/v1/admin/system/permissions": PathItem(),
                "api/v1/admin/system/permissions/query": Query.PathItem(),
                "api/v1/admin/system/permissions/{systemPermissionId}":
                    Get.PathItem(),
            ]
        }
    }
}
