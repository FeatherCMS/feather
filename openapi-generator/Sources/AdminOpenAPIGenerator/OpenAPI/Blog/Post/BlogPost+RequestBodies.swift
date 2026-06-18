import FeatherOpenAPI
import OpenAPIKit30

struct BlogPostRequestBody: RequestBodyRepresentable {
    var contentMap: ContentMap {
        [
            .json: Content(BlogPostCreateSchema().reference())
        ]
    }
}

struct BlogPostUpdateRequestBody: RequestBodyRepresentable {
    var contentMap: ContentMap {
        [
            .json: Content(BlogPostCreateSchema().reference())
        ]
    }
}

struct BlogPostPatchRequestBody: RequestBodyRepresentable {
    var contentMap: ContentMap {
        [
            .json: Content(BlogPostPatchSchema().reference())
        ]
    }
}
