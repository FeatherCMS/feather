import FeatherOpenAPI
import FeatherOpenAPIGenerator
import OpenAPIKit30

struct PathCollection: PathCollectionRepresentable {

    var pathMap: PathMap {
        [
            "api/v1/admin/system/permissions": SystemPermissionPathItems(),
            "api/v1/admin/system/permissions/":
                SystemPermissionListPathItems(),
            "api/v1/admin/system/permissions/search":
                SystemPermissionSearchPathItems(),
            "api/v1/admin/system/permissions/{systemPermissionId}":
                SystemPermissionIdPathItems(),
            "api/v1/admin/system/variables": SystemVariablePathItems(),
            "api/v1/admin/system/variables/":
                SystemVariableListPathItems(),
            "api/v1/admin/system/variables/search":
                SystemVariableSearchPathItems(),
            "api/v1/admin/system/variables/{systemVariableId}":
                SystemVariableIdPathItems(),
            "api/v1/admin/system/jobs": SystemJobPathItems(),
            "api/v1/admin/system/jobs/{systemJobId}": SystemJobIDPathItems(),
        ]
    }
}
