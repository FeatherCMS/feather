import FeatherOpenAPI
import OpenAPIKit30

struct WebMenuItemRequestBody: RequestBodyRepresentable {
    var contentMap: ContentMap {
        [
            .json: Content(WebMenuItemCreateSchema().reference())
        ]
    }
}

struct WebMenuItemUpdateRequestBody: RequestBodyRepresentable {
    var contentMap: ContentMap {
        [
            .json: Content(WebMenuItemCreateSchema().reference())
        ]
    }
}

struct WebMenuItemPatchRequestBody: RequestBodyRepresentable {
    var contentMap: ContentMap {
        [
            .json: Content(WebMenuItemPatchSchema().reference())
        ]
    }
}
