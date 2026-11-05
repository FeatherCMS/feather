import FeatherOpenAPI

extension Category.Post {
    struct RequestBody: RequestBodyRepresentable {
        var openAPIIdentifier: String { "NewsCategoryRequestBody" }
        var contentMap: ContentMap {
            [.json: Content(Category.Schemas.Create().reference())]
        }
    }
}
