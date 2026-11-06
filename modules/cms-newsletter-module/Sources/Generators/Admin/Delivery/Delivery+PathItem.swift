import FeatherOpenAPI

extension Delivery {
    struct PathItem: PathItemRepresentable {
        var get: (any OperationRepresentable)? {
            List.Operation()
        }
    }
}
