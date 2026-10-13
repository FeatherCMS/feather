import FeatherOpenAPI
import OpenAPIKit30

struct BlogAuthorLinkRequestBody: RequestBodyRepresentable {
    var contentMap: ContentMap {
        [
            .json: Content(BlogAuthorLinkCreateSchema().reference())
        ]
    }
}

struct BlogAuthorLinkUpdateRequestBody: RequestBodyRepresentable {
    var contentMap: ContentMap {
        [
            .json: Content(BlogAuthorLinkCreateSchema().reference())
        ]
    }
}

struct BlogAuthorLinkPatchRequestBody: RequestBodyRepresentable {
    var contentMap: ContentMap {
        [
            .json: Content(BlogAuthorLinkPatchSchema().reference())
        ]
    }
}
