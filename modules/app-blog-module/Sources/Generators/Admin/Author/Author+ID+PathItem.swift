import FeatherOpenAPI

extension Author.ID {
    struct PathItem: PathItemRepresentable {
        var get: (any OperationRepresentable)? { Author.Get.Operation() }
        var patch: (any OperationRepresentable)? {
            Author.Patch.Operation()
        }
    }
}
