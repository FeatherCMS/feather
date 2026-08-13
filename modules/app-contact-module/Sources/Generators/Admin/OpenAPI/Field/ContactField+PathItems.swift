import FeatherOpenAPI

struct ContactFieldPathItems: PathItemRepresentable {
    var get: OperationRepresentable? { ContactFieldListOperation() }
    var post: OperationRepresentable? { ContactFieldCreateOperation() }
    var delete: OperationRepresentable? { ContactFieldBulkDeleteOperation() }
}
struct ContactFieldIDPathItems: PathItemRepresentable {
    var get: OperationRepresentable? { ContactFieldGetOperation() }
    var put: OperationRepresentable? { ContactFieldUpdateOperation() }
    var delete: OperationRepresentable? { ContactFieldDeleteOperation() }
}
struct FormFieldPathItems: PathItemRepresentable {
    var get: OperationRepresentable? { FormFieldListOperation() }
    var post: OperationRepresentable? { FormFieldCreateOperation() }
    var delete: OperationRepresentable? { FormFieldBulkDeleteOperation() }
}
struct FormFieldIDPathItems: PathItemRepresentable {
    var get: OperationRepresentable? { FormFieldGetOperation() }
    var put: OperationRepresentable? { FormFieldUpdateOperation() }
    var delete: OperationRepresentable? { FormFieldDeleteOperation() }
}
