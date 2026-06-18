import AuthDomain

extension RolePermission {

    var asDetail: RolePermissionDetail {
        .init(
            roleId: roleId,
            permissionId: permissionId,
            createdAt: createdAt,
            updatedAt: updatedAt
        )
    }
}
