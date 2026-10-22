import OpenAPIKit30
import WebSharedOpenAPIGenerator
public import FeatherOpenAPI
public import FeatherOpenAPIGenerator

public protocol WebMetadataIDOperation: WebMetadataOperation {
}

extension WebMetadataIDOperation {
    public var parameters: [any ParameterRepresentable] {
        [
            WebMetadataIdParameter().reference()
        ]
    }
}
