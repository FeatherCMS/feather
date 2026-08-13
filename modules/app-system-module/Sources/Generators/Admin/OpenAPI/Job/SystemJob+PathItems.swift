import FeatherOpenAPI

struct SystemJobPathItems: PathItemRepresentable {
    var get: OperationRepresentable? { SystemJobListOperation() }
}

struct SystemJobIDPathItems: PathItemRepresentable {
    var get: OperationRepresentable? { SystemJobGetOperation() }
}
