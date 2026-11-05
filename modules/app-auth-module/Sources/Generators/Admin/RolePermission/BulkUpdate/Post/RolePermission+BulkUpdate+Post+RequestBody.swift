import FeatherOpenAPI

extension RolePermission.BulkUpdate.Post {
    struct RequestBody: RequestBodyRepresentable {
        var openAPIIdentifier: String {
            "AuthRolePermissionBulkUpdateRequestBody"
        }

        var contentMap: ContentMap {
            [.json: Content(Schema().reference())]
        }
    }
}
