import FeatherOpenAPI

struct ContactFormPathItems: PathItemRepresentable {
    var get: (any OperationRepresentable)? { ContactFormListOperation() }
    var post: (any OperationRepresentable)? { ContactFormCreateOperation() }
    var delete: (any OperationRepresentable)? { ContactFormRemoveOperation() }
}
struct ContactFormIDPathItems: PathItemRepresentable {
    var get: (any OperationRepresentable)? { ContactFormGetOperation() }
    var put: (any OperationRepresentable)? { ContactFormUpdateOperation() }
}
