import FeatherOpenAPI

struct AccountCreateRequestBody: RequestBodyRepresentable {
    var contentMap: ContentMap {
        [.json: Content(AccountCreateSchema().reference())]
    }
}
