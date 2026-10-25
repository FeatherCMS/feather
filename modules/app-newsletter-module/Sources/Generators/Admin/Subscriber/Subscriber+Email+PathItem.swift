import FeatherOpenAPI

extension Subscriber.Email {
    struct PathItem: PathItemRepresentable {
        var get: (any OperationRepresentable)? {
            Subscriber.Get.Operation()
        }
        var patch: (any OperationRepresentable)? {
            Subscriber.Patch.Operation()
        }
    }
}
