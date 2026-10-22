public import FeatherOpenAPI
import FeatherOpenAPIGenerator
import OpenAPIKit30
import WebSharedOpenAPIGenerator

public protocol WebMetadataIDOperation: WebMetadataOperation {
}

extension WebMetadataIDOperation {
    public var parameters: [any ParameterRepresentable] {
        [
            WebMetadataIdParameter().reference()
        ]
    }
}
