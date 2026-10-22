import OpenAPIKit30
import WebSharedOpenAPIGenerator
public import FeatherOpenAPI
public import FeatherOpenAPIGenerator

public protocol WebMenuItemMenuOperation: WebMenuItemOperation {
}

extension WebMenuItemMenuOperation {
    public var parameters: [any ParameterRepresentable] {
        [
            WebMenuItemMenuIdParameter().reference()
        ]
    }
}
