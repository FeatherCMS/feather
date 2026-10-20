import FeatherOpenAPI

struct UserRoleRequestBody: RequestBodyRepresentable {
    var contentMap: ContentMap {
        [
            .json: Content(UserRoleCreateSchema().reference())
        ]
    }
}

struct UserRoleUpdateRequestBody: RequestBodyRepresentable {
    var contentMap: ContentMap {
        [
            .json: Content(UserRoleUpdateSchema().reference())
        ]
    }
}
