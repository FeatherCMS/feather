import FeatherOpenAPI

extension Account.Create {
    struct RequestBody: RequestBodyRepresentable {
        var openAPIIdentifier: String { "AccountCreateRequestBody" }
        var contentMap: ContentMap {
            [.json: Content(Schema().reference())]
        }
    }
}
