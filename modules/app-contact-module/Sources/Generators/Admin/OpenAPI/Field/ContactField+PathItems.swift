import FeatherOpenAPI

struct ContactFieldPathItems: PathItemRepresentable {
    var get: OperationRepresentable? { ContactFieldListOperation() }
    var post: OperationRepresentable? { ContactFieldCreateOperation() }
    var delete: OperationRepresentable? { ContactFieldRemoveOperation() }
}
struct ContactFieldIDPathItems: PathItemRepresentable {
    var get: OperationRepresentable? { ContactFieldGetOperation() }
    var put: OperationRepresentable? { ContactFieldUpdateOperation() }
}
