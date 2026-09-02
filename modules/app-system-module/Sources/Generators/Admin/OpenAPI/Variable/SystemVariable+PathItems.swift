import FeatherOpenAPI

struct SystemVariablePathItems: PathItemRepresentable {
    var post: OperationRepresentable? { SystemVariableCreateOperation() }
    var delete: OperationRepresentable? { SystemVariableDeleteOperation() }
}

struct SystemVariableSearchPathItems: PathItemRepresentable {
    var post: OperationRepresentable? { SystemVariableSearchOperation() }
}

struct SystemVariableListPathItems: PathItemRepresentable {
    var get: OperationRepresentable? { SystemVariableListOperation() }
}

struct SystemVariableIdPathItems: PathItemRepresentable {
    var get: OperationRepresentable? { SystemVariableGetOperation() }
    var put: OperationRepresentable? { SystemVariableUpdateOperation() }
    var patch: OperationRepresentable? { SystemVariablePatchOperation() }
}
