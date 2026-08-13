import FeatherOpenAPI
import OpenAPIKit30

struct WebMenuRequestBody: RequestBodyRepresentable {
    var contentMap: ContentMap {
        [
            .json: Content(WebMenuCreateSchema().reference())
        ]
    }
}

struct WebMenuUpdateRequestBody: RequestBodyRepresentable {
    var contentMap: ContentMap {
        [
            .json: Content(WebMenuCreateSchema().reference())
        ]
    }
}

struct WebMenuPatchRequestBody: RequestBodyRepresentable {
    var contentMap: ContentMap {
        [
            .json: Content(WebMenuPatchSchema().reference())
        ]
    }
}
