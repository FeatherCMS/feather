import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension Identity.Patch {
    struct PathItem: PathItemRepresentable {
        var patch: (any OperationRepresentable)? { Operation() }
    }
}
