import FeatherOpenAPI
import OpenAPIKit30

extension Invitation.Patch {
    struct RequestBody: FeatherOpenAPI.RequestBodyRepresentable {
        var contentMap: ContentMap {
            [.json: Content(Schema().reference())]
        }
    }
}
