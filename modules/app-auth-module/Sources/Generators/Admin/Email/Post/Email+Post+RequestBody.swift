import FeatherOpenAPI

extension Email.Post {
    struct RequestBody: RequestBodyRepresentable {
        var contentMap: ContentMap {
            [.json: Content(Email.Schemas.Create().reference())]
        }
    }
}
