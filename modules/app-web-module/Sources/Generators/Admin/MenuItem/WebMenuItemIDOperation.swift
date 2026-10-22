import OpenAPIKit30
import WebSharedOpenAPIGenerator
public import FeatherOpenAPI
public import FeatherOpenAPIGenerator

public protocol WebMenuItemIDOperation: WebMenuItemMenuOperation {
}

extension WebMenuItemIDOperation {
    public var parameters: [any ParameterRepresentable] {
        [
            WebMenuItemMenuIdParameter().reference(),
            WebMenuItemIdParameter().reference(),
        ]
    }
}
