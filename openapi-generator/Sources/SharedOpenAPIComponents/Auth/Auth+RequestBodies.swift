import FeatherOpenAPI
import OpenAPIKit30

struct AuthLoginRequestBody: RequestBodyRepresentable {

    var contentMap: ContentMap {
        [
            .json: Content(AuthLoginRequestSchema().reference())
        ]
    }
}

struct AuthMagicLinkRequestBody: RequestBodyRepresentable {

    var contentMap: ContentMap {
        [
            .json: Content(AuthMagicLinkRequestSchema().reference())
        ]
    }
}

struct AuthMagicLinkVerifyRequestBody: RequestBodyRepresentable {

    var contentMap: ContentMap {
        [
            .json: Content(AuthMagicLinkVerifyRequestSchema().reference())
        ]
    }
}
