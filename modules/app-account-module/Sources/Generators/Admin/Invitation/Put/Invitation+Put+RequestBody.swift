import FeatherOpenAPI

extension Invitation.Put {
    struct RequestBody: FeatherOpenAPI.RequestBodyRepresentable {
        var contentMap: ContentMap {
            [.json: Content(Schema().reference())]
        }
    }
}
