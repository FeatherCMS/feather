public import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension Metadata.Slug {
    struct PathItem: PathItemRepresentable {
        var get: (any OperationRepresentable)? { Metadata.Get.Operation() }
    }
}

extension Metadata {
    enum Slug {}
}
