import FeatherOpenAPI

extension Category.Put {
    struct RequestBody: RequestBodyRepresentable {
        var openAPIIdentifier: String { "NewsCategoryUpdateRequestBody" }
        var contentMap: ContentMap {
            [.json: Content(Category.Schemas.Create().reference())]
        }
    }
}
