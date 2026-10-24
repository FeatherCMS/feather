public import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension Menu.Key {
    struct PathItem: PathItemRepresentable {
        var get: (any OperationRepresentable)? { Get.Operation() }
    }
}
