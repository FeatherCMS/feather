public import FeatherOpenAPI
import FeatherOpenAPIGenerator
import OpenAPIKit30
import WebSharedOpenAPIGenerator

public protocol WebMenuItemMenuOperation: WebMenuItemOperation {
}

extension WebMenuItemMenuOperation {
    public var parameters: [any ParameterRepresentable] {
        [
            WebMenuItemMenuIdParameter().reference()
        ]
    }
}
