import FeatherOpenAPI
import OpenAPIKit30

struct SystemPermissionRequestBody: RequestBodyRepresentable {
    var contentMap: ContentMap {
        [
            .json: Content(SystemPermissionCreateSchema().reference())
        ]
    }
}

struct SystemPermissionUpdateRequestBody: RequestBodyRepresentable {
    var contentMap: ContentMap {
        [
            .json: Content(SystemPermissionCreateSchema().reference())
        ]
    }
}

struct SystemPermissionPatchRequestBody: RequestBodyRepresentable {
    var contentMap: ContentMap {
        [
            .json: Content(SystemPermissionPatchSchema().reference())
        ]
    }
}
