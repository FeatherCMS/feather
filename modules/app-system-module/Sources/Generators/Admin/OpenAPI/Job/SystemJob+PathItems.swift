import FeatherOpenAPI

struct SystemJobPathItems: PathItemRepresentable {
    var get: (any OperationRepresentable)? { SystemJobListOperation() }
}

struct SystemJobIDPathItems: PathItemRepresentable {
    var get: (any OperationRepresentable)? { SystemJobGetOperation() }
}
