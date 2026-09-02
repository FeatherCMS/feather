import FeatherOpenAPI

struct ContactFieldPathItems: PathItemRepresentable {
    var get: OperationRepresentable? { ContactFieldListOperation() }
    var post: OperationRepresentable? { ContactFieldCreateOperation() }
    var delete: OperationRepresentable? { ContactFieldDeleteOperation() }
}
struct ContactFieldIDPathItems: PathItemRepresentable {
    var get: OperationRepresentable? { ContactFieldGetOperation() }
    var put: OperationRepresentable? { ContactFieldUpdateOperation() }
}
struct FormFieldPathItems: PathItemRepresentable {
    var get: OperationRepresentable? { FormFieldListOperation() }
    var post: OperationRepresentable? { FormFieldCreateOperation() }
    var delete: OperationRepresentable? { FormFieldDeleteOperation() }
}
struct FormFieldIDPathItems: PathItemRepresentable {
    var get: OperationRepresentable? { FormFieldGetOperation() }
    var put: OperationRepresentable? { FormFieldUpdateOperation() }
}
