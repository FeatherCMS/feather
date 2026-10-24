public import FeatherOpenAPI
import OpenAPIKit30

struct MenuRequestBody: RequestBodyRepresentable {
    var contentMap: ContentMap {
        [
            .json: Content(MenuCreateSchema().reference())
        ]
    }
}

struct MenuUpdateRequestBody: RequestBodyRepresentable {
    var contentMap: ContentMap {
        [
            .json: Content(MenuCreateSchema().reference())
        ]
    }
}

struct MenuPatchRequestBody: RequestBodyRepresentable {
    var contentMap: ContentMap {
        [
            .json: Content(MenuPatchSchema().reference())
        ]
    }
}
