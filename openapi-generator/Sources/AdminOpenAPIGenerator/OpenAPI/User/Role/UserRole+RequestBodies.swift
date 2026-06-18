import FeatherOpenAPI
import OpenAPIKit30

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
            .json: Content(UserRoleCreateSchema().reference())
        ]
    }
}

struct UserRolePatchRequestBody: RequestBodyRepresentable {
    var contentMap: ContentMap {
        [
            .json: Content(UserRolePatchSchema().reference())
        ]
    }
}
