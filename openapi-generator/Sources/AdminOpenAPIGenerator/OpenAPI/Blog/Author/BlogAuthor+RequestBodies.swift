import FeatherOpenAPI
import OpenAPIKit30

struct BlogAuthorRequestBody: RequestBodyRepresentable {
    var contentMap: ContentMap {
        [
            .json: Content(BlogAuthorCreateSchema().reference())
        ]
    }
}

struct BlogAuthorUpdateRequestBody: RequestBodyRepresentable {
    var contentMap: ContentMap {
        [
            .json: Content(BlogAuthorCreateSchema().reference())
        ]
    }
}

struct BlogAuthorPatchRequestBody: RequestBodyRepresentable {
    var contentMap: ContentMap {
        [
            .json: Content(BlogAuthorPatchSchema().reference())
        ]
    }
}
