import FeatherOpenAPI

extension RolePermission.Post {

    struct RequestBody: RequestBodyRepresentable {
        var openAPIIdentifier: String { "AuthRolePermissionRequestBody" }
        var contentMap: ContentMap {
            [
                .json: Content(
                    Schema()
                        .reference()
                )
            ]
        }
    }
}
