import FeatherOpenAPI

extension Variable.Post {
    struct RequestBody: RequestBodyRepresentable {
        var openAPIIdentifier: String { "SystemVariableRequestBody" }
        var contentMap: ContentMap {
            [.json: Content(Schema().reference())]
        }
    }
}
