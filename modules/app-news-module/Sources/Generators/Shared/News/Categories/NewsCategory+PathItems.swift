public import FeatherOpenAPI
import FeatherOpenAPIGenerator

public struct NewsCategoryListPathItems: PathItemRepresentable {
    public var get: (any OperationRepresentable)? {
        NewsCategoryListOperation()
    }

    public init() {}
}

public struct NewsCategoryGetPathItems: PathItemRepresentable {
    public var get: (any OperationRepresentable)? { NewsCategoryGetOperation() }

    public init() {}
}
