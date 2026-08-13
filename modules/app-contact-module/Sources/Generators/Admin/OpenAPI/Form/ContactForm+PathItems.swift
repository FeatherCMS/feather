import FeatherOpenAPI

struct ContactFormPathItems: PathItemRepresentable {
    var get: OperationRepresentable? { ContactFormListOperation() }
    var post: OperationRepresentable? { ContactFormCreateOperation() }
    var delete: OperationRepresentable? { ContactFormBulkDeleteOperation() }
}
struct ContactFormIDPathItems: PathItemRepresentable {
    var get: OperationRepresentable? { ContactFormGetOperation() }
    var put: OperationRepresentable? { ContactFormUpdateOperation() }
    var delete: OperationRepresentable? { ContactFormDeleteOperation() }
}
