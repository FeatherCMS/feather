import FeatherOpenAPI

struct SystemVariablePathItems: PathItemRepresentable {
    var post: (any OperationRepresentable)? { SystemVariableCreateOperation() }
    var delete: (any OperationRepresentable)? { SystemVariableRemoveOperation() }
}

struct SystemVariableSearchPathItems: PathItemRepresentable {
    var post: (any OperationRepresentable)? { SystemVariableSearchOperation() }
}

struct SystemVariableListPathItems: PathItemRepresentable {
    var get: (any OperationRepresentable)? { SystemVariableListOperation() }
}

struct SystemVariableIdPathItems: PathItemRepresentable {
    var get: (any OperationRepresentable)? { SystemVariableGetOperation() }
    var put: (any OperationRepresentable)? { SystemVariableUpdateOperation() }
    var patch: (any OperationRepresentable)? { SystemVariablePatchOperation() }
}
