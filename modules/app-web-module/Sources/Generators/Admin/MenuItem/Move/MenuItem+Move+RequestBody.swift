import FeatherOpenAPI

extension MenuItem.Move {
    struct RequestBody: RequestBodyRepresentable {
        var openAPIIdentifier: String { "MenuItemMoveRequestBody" }
        var contentMap: ContentMap {
            [.json: Content(Schema().reference())]
        }
    }
}
