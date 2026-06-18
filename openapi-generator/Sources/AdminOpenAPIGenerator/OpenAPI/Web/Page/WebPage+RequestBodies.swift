import FeatherOpenAPI
import OpenAPIKit30

struct WebPageRequestBody: RequestBodyRepresentable {
    var contentMap: ContentMap {
        [
            .json: Content(WebPageCreateSchema().reference())
        ]
    }
}

struct WebPageUpdateRequestBody: RequestBodyRepresentable {
    var contentMap: ContentMap {
        [
            .json: Content(WebPageCreateSchema().reference())
        ]
    }
}

struct WebPagePatchRequestBody: RequestBodyRepresentable {
    var contentMap: ContentMap {
        [
            .json: Content(WebPagePatchSchema().reference())
        ]
    }
}
