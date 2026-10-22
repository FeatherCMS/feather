public import FeatherOpenAPI
import FeatherOpenAPIGenerator
import OpenAPIKit30
import WebSharedOpenAPIGenerator

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
