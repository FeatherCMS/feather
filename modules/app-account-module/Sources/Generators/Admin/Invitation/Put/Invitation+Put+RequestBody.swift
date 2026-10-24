import FeatherOpenAPI
import OpenAPIKit30

extension Invitation.Put {
    struct RequestBody: FeatherOpenAPI.RequestBodyRepresentable {
        var contentMap: ContentMap {
            [.json: Content(Schema().reference())]
        }
    }
}
