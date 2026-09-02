import FeatherOpenAPI

struct ContactFormPathItems: PathItemRepresentable {
    var get: OperationRepresentable? { ContactFormListOperation() }
    var post: OperationRepresentable? { ContactFormCreateOperation() }
    var delete: OperationRepresentable? { ContactFormDeleteOperation() }
}
struct ContactFormIDPathItems: PathItemRepresentable {
    var get: OperationRepresentable? { ContactFormGetOperation() }
    var put: OperationRepresentable? { ContactFormUpdateOperation() }
}
