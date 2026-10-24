import FeatherOpenAPI
import OpenAPIKit30

extension Invitation.Post {
    struct RequestBody: FeatherOpenAPI.RequestBodyRepresentable {
        var contentMap: ContentMap {
            [.json: Content(Schema().reference())]
        }
    }
}
