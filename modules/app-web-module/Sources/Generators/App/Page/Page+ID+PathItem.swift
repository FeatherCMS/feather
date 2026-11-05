public import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension Page.ID {
    struct PathItem: PathItemRepresentable {
        var get: (any OperationRepresentable)? { Get.Operation() }
    }
}
