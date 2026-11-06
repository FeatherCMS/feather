public import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension MenuItem {
    public protocol Operation: OperationRepresentable {}
    public protocol MenuOperation: Operation {}
    public protocol IdentifiableOperation: MenuOperation {}
}

extension MenuItem.Operation {
    public var tags: [any TagRepresentable] { [MenuItem.Tag()] }
}

extension MenuItem.MenuOperation {
    public var parameters: [any ParameterRepresentable] {
        [MenuItem.Parameters.MenuID().reference()]
    }
}

extension MenuItem.IdentifiableOperation {
    public var parameters: [any ParameterRepresentable] {
        [
            MenuItem.Parameters.MenuID().reference(),
            MenuItem.Parameters.ID().reference(),
        ]
    }
}
