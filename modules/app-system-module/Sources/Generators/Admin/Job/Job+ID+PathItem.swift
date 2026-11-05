import FeatherOpenAPI

extension Job.ID {
    struct PathItem: PathItemRepresentable {
        var get: (any OperationRepresentable)? { Job.Get.Operation() }
    }
}
