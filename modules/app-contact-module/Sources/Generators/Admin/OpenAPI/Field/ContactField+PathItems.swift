import FeatherOpenAPI

struct ContactFieldPathItems: PathItemRepresentable {
    var get: (any OperationRepresentable)? { ContactFieldListOperation() }
    var post: (any OperationRepresentable)? { ContactFieldCreateOperation() }
    var delete: (any OperationRepresentable)? { ContactFieldRemoveOperation() }
}
struct ContactFieldIDPathItems: PathItemRepresentable {
    var get: (any OperationRepresentable)? { ContactFieldGetOperation() }
    var put: (any OperationRepresentable)? { ContactFieldUpdateOperation() }
}
