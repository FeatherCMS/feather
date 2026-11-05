public import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension Settings {
    struct PathItem: PathItemRepresentable {
        var get: (any OperationRepresentable)? { Get.Operation() }
    }
}
