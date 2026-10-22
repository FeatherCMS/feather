public import FeatherOpenAPI
import FeatherOpenAPIGenerator
import OpenAPIKit30
import WebSharedOpenAPIGenerator

public protocol MenuItemMenuOperation: MenuItemOperation {
}

extension MenuItemMenuOperation {
    public var parameters: [any ParameterRepresentable] {
        [
            MenuItemMenuIdParameter().reference()
        ]
    }
}
