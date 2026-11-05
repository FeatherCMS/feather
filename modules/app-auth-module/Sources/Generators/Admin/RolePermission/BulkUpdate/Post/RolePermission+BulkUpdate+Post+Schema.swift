import FeatherOpenAPI

extension RolePermission.BulkUpdate.Post {
    struct Schema: ObjectSchemaRepresentable {
        var openAPIIdentifier: String {
            "AuthRolePermissionBulkUpdateSchema"
        }

        var propertyMap: SchemaMap {
            [
                "additions": PairList().reference(),
                "removals": PairList().reference(),
            ]
        }
    }
}
