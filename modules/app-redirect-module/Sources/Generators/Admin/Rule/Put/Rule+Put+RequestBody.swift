import FeatherOpenAPI

extension Rule.Put {
    struct RequestBody: RequestBodyRepresentable {
        var openAPIIdentifier: String { "RedirectRuleUpdateRequestBody" }
        var contentMap: ContentMap {
            [.json: Content(Rule.Schemas.Create().reference())]
        }
    }
}
