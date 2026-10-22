public import FeatherOpenAPI
import FeatherOpenAPIGenerator
import OpenAPIKit30
import WebSharedOpenAPIGenerator

public protocol MetadataIDOperation: MetadataOperation {
}

extension MetadataIDOperation {
    public var parameters: [any ParameterRepresentable] {
        [
            MetadataIdParameter().reference()
        ]
    }
}
