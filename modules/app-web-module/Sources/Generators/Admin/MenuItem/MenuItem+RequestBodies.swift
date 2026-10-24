public import FeatherOpenAPI

struct MenuItemRequestBody: RequestBodyRepresentable {
    var contentMap: ContentMap {
        [
            .json: Content(MenuItemCreateSchema().reference())
        ]
    }
}

struct MenuItemUpdateRequestBody: RequestBodyRepresentable {
    var contentMap: ContentMap {
        [
            .json: Content(MenuItemCreateSchema().reference())
        ]
    }
}

struct MenuItemPatchRequestBody: RequestBodyRepresentable {
    var contentMap: ContentMap {
        [
            .json: Content(MenuItemPatchSchema().reference())
        ]
    }
}
