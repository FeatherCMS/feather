public import FeatherOpenAPI
import FeatherOpenAPIGenerator
import OpenAPIKit30
import WebSharedOpenAPIGenerator

public protocol WebPageIDOperation: WebPageOperation {
}

extension WebPageIDOperation {
    public var parameters: [any ParameterRepresentable] {
        [
            WebPageIdParameter().reference()
        ]
    }
}
