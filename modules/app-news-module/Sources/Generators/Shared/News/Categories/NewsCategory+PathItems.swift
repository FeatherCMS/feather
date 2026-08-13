import FeatherOpenAPI
import FeatherOpenAPIGenerator

public struct NewsCategoryListPathItems: PathItemRepresentable {
    public var get: OperationRepresentable? { NewsCategoryListOperation() }

    public init() {}
}

public struct NewsCategoryGetPathItems: PathItemRepresentable {
    public var get: OperationRepresentable? { NewsCategoryGetOperation() }

    public init() {}
}
