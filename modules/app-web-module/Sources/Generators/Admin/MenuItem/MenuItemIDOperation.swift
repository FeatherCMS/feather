public import FeatherOpenAPI
import FeatherOpenAPIGenerator
import OpenAPIKit30
import WebSharedOpenAPIGenerator

public protocol MenuItemIDOperation: MenuItemMenuOperation {
}

extension MenuItemIDOperation {
    public var parameters: [any ParameterRepresentable] {
        [
            MenuItemMenuIdParameter().reference(),
            MenuItemIdParameter().reference(),
        ]
    }
}
