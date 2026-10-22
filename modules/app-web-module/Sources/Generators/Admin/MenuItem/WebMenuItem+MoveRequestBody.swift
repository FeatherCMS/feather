import FeatherOpenAPI
import OpenAPIKit30

struct WebMenuItemMoveRequestBody: RequestBodyRepresentable {
    var contentMap: ContentMap {
        [
            .json: Content(WebMenuItemMoveSchema().reference())
        ]
    }
}
