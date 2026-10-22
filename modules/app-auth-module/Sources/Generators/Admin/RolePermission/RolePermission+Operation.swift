public import FeatherOpenAPI
public import FeatherOpenAPIGenerator
import UserOpenAPIGeneratorSupport

public protocol AuthRolePermissionOperation: BearerProtectedOperation {}

extension AuthRolePermissionOperation {
    public var tags: [any TagRepresentable] { [AuthRolePermissionTag()] }
}

public protocol AuthRolePermissionIdOperation: AuthRolePermissionOperation {}

extension AuthRolePermissionIdOperation {
    public var parameters: [any ParameterRepresentable] {
        [
            AuthRolePermissionRoleIdParameter().reference(),
            AuthRolePermissionPermissionIdParameter().reference(),
        ]
    }
}
