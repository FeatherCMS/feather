import FeatherOpenAPI

extension Job.Get {
    struct PathItem: PathItemRepresentable {
        var get: (any OperationRepresentable)? { Job.Get.Operation() }
    }
}
