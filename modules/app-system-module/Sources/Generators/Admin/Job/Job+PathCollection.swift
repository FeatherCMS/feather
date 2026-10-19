import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension Job {
    struct PathCollection: PathCollectionRepresentable {
        var pathMap: PathMap {
            [
                "api/v1/admin/system/jobs": List.PathItem(),
                "api/v1/admin/system/jobs/{systemJobId}": Get.PathItem(),
            ]
        }
    }
}
