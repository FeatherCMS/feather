import OpenAPIKit30
import WebSharedOpenAPIGenerator
public import FeatherOpenAPI
public import FeatherOpenAPIGenerator

public protocol WebPageIDOperation: WebPageOperation {
}

extension WebPageIDOperation {
    public var parameters: [any ParameterRepresentable] {
        [
            WebPageIdParameter().reference()
        ]
    }
}
