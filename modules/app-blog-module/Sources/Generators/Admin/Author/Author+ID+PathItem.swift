import FeatherOpenAPI

extension Author.ID {
    struct PathItem: PathItemRepresentable {
        var get: (any OperationRepresentable)? { Author.Get.Operation() }
        var put: (any OperationRepresentable)? { Author.Put.Operation() }
        var patch: (any OperationRepresentable)? {
            Author.Patch.Operation()
        }
    }
}
