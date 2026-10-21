import FeatherOpenAPI

struct UserRoleRequestBody: RequestBodyRepresentable {
    var contentMap: ContentMap {
        [
            .json: Content(Role.Post.Schema().reference())
        ]
    }
}

struct UserRoleUpdateRequestBody: RequestBodyRepresentable {
    var contentMap: ContentMap {
        [
            .json: Content(Role.Put.Schema().reference())
        ]
    }
}
