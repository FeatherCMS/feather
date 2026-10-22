public import FeatherOpenAPI
public import FeatherOpenAPIGenerator
import UserOpenAPIGeneratorSupport

extension RolePermission {
    public protocol Operation: BearerProtectedOperation {}
}

extension RolePermission.Operation {
    public var tags: [any TagRepresentable] { [RolePermission.Tag()] }
}

extension RolePermission {
    public protocol IdentifiableOperation: RolePermission.Operation {}
}

extension RolePermission.IdentifiableOperation {
    public var parameters: [any ParameterRepresentable] {
        [
            RolePermission.Parameters.RoleID()
                .reference(),
            RolePermission.Parameters.PermissionID()
                .reference(),
        ]
    }
}
