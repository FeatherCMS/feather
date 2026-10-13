import FeatherOpenAPI
import OpenAPIKitCore

struct AccountCreateRequestBody: RequestBodyRepresentable {
    var contentMap: ContentMap {
        [.json: Content(AccountCreateSchema().reference())]
    }
}
