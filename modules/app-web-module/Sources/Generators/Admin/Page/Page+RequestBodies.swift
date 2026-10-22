public import FeatherOpenAPI
import OpenAPIKit30

struct PageRequestBody: RequestBodyRepresentable {
    var contentMap: ContentMap {
        [
            .json: Content(PageCreateSchema().reference())
        ]
    }
}

struct PageUpdateRequestBody: RequestBodyRepresentable {
    var contentMap: ContentMap {
        [
            .json: Content(PagePatchSchema().reference())
        ]
    }
}

struct PagePatchRequestBody: RequestBodyRepresentable {
    var contentMap: ContentMap {
        [
            .json: Content(PagePatchSchema().reference())
        ]
    }
}
