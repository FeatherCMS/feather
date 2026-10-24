public import FeatherOpenAPI

struct MenuItemMoveRequestBody: RequestBodyRepresentable {
    var contentMap: ContentMap {
        [
            .json: Content(MenuItemMoveSchema().reference())
        ]
    }
}
