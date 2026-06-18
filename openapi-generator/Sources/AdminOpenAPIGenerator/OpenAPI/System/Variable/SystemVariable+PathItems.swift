import FeatherOpenAPI

struct SystemVariablePathItems: PathItemRepresentable {
    var post: OperationRepresentable? { SystemVariableCreateOperation() }
    var delete: OperationRepresentable? { SystemVariableBulkDeleteOperation() }
}

struct SystemVariableSearchPathItems: PathItemRepresentable {
    var post: OperationRepresentable? { SystemVariableSearchOperation() }
}

struct SystemVariableFiltersPathItems: PathItemRepresentable {
    var get: OperationRepresentable? { SystemVariableFiltersOperation() }
}

struct SystemVariableIdPathItems: PathItemRepresentable {
    var get: OperationRepresentable? { SystemVariableGetOperation() }
    var put: OperationRepresentable? { SystemVariableUpdateOperation() }
    var patch: OperationRepresentable? { SystemVariablePatchOperation() }
    var delete: OperationRepresentable? { SystemVariableDeleteOperation() }
}
