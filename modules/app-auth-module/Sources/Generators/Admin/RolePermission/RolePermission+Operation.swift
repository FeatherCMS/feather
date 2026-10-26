public import FeatherOpenAPI
public import FeatherOpenAPIGenerator
import UserOpenAPIGeneratorSupport

extension RolePermission {
    public protocol Operation: BearerProtectedOperation {}
    }

    extension Operation {
    public var tags: [any TagRepresentable] { [Tag()] }
    }

    extension RolePermission {
    public protocol IdentifiableOperation: Operation {}
    }

    extension IdentifiableOperation {
    public var parameters: [any ParameterRepresentable] {
        [
            Parameters.RoleID()
                .reference(),
            Parameters.PermissionID()
                .reference(),
        ]
    }
}
