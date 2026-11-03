import FeatherOpenAPI

extension RolePermission.BulkUpdate.Post {
    struct PairList: ArraySchemaRepresentable {
        var openAPIIdentifier: String {
            "AuthRolePermissionBulkUpdatePairListSchema"
        }

        var items: (any SchemaRepresentable)? {
            RolePermission.Schemas.Pair().reference()
        }
    }
}
