import FeatherOpenAPI
import OpenAPIKit30

extension Rule.Patch {
    struct RequestBody: RequestBodyRepresentable {
        var openAPIIdentifier: String { "RedirectRulePatchRequestBody" }
        var contentMap: ContentMap {
            [.json: Content(Schema().reference())]
        }
    }
}
