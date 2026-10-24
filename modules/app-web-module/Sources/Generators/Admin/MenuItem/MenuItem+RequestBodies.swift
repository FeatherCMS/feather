public import FeatherOpenAPI
import OpenAPIKit30

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
