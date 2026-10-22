public import FeatherOpenAPI
import FeatherOpenAPIGenerator
import OpenAPIKit30
import WebSharedOpenAPIGenerator

public protocol PageIDOperation: PageOperation {
}

extension PageIDOperation {
    public var parameters: [any ParameterRepresentable] {
        [
            PageIdParameter().reference()
        ]
    }
}
