import FeatherOpenAPI

extension Variable.Get {
    struct PathItem: PathItemRepresentable {
        var get: (any OperationRepresentable)? { Variable.Get.Operation() }
        var put: (any OperationRepresentable)? { Variable.Put.Operation() }
        var patch: (any OperationRepresentable)? { Variable.Patch.Operation() }
    }
}
