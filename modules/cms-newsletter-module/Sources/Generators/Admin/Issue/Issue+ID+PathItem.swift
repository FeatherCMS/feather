import FeatherOpenAPI

extension Issue.ID {
    struct PathItem: PathItemRepresentable {
        var get: (any OperationRepresentable)? {
            Issue.Get.Operation()
        }
        var patch: (any OperationRepresentable)? {
            Issue.Patch.Operation()
        }
    }
}
