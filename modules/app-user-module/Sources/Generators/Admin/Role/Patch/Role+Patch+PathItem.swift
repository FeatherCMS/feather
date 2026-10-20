import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension Role.Patch {
    struct PathItem: PathItemRepresentable {
        var patch: (any OperationRepresentable)? { Operation() }
    }
}
