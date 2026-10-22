import FeatherOpenAPI
import OpenAPIKit30

struct BlogTagRequestBody: RequestBodyRepresentable {
    var contentMap: ContentMap {
        [
            .json: Content(BlogTagCreateSchema().reference())
        ]
    }
}

struct BlogTagUpdateRequestBody: RequestBodyRepresentable {
    var contentMap: ContentMap {
        [
            .json: Content(BlogTagPatchSchema().reference())
        ]
    }
}

struct BlogTagPatchRequestBody: RequestBodyRepresentable {
    var contentMap: ContentMap {
        [
            .json: Content(BlogTagPatchSchema().reference())
        ]
    }
}
