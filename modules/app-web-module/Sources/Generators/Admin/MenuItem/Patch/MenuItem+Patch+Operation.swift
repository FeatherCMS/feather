import FeatherOpenAPI
import FeatherOpenAPIGenerator
import OpenAPIKit30
import WebOpenAPIGeneratorSupport

extension MenuItem.Patch {
    struct Operation: MenuItem.IdentifiableOperation, BearerProtectedOperation {
        var operationId: String? { "menuItemPatch" }
        var requestBody: (any RequestBodyRepresentable)? {
            MenuItemPatchRequestBody().reference()
        }

        var responseMap: ResponseMap {
            [
                200: MenuItemDetailResponse().reference(),
                404: CustomResponse(description: "MenuItem not found"),
            ]
        }
    }
}
