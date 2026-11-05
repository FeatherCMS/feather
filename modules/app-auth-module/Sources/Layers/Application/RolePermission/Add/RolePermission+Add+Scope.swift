public import AuthDomain
public import AuthModule
public import FeatherModuleKit

extension RolePermission.Add {
    public struct Scope: FeatherModuleKit.Scope {
        public let rolePermissions: any RolePermission.Repository.Interface
        public init(rolePermissions: any RolePermission.Repository.Interface) {
            self.rolePermissions = rolePermissions
        }
    }
}
