import FeatherOpenAPI

extension Contact {
    protocol Operation: OperationRepresentable {
        var operationId: String? { get }
    }
}
