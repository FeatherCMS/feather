public import FeatherOpenAPI
import OpenAPIKit30

struct MenuItemMoveRequestBody: RequestBodyRepresentable {
    var contentMap: ContentMap {
        [
            .json: Content(MenuItemMoveSchema().reference())
        ]
    }
}
