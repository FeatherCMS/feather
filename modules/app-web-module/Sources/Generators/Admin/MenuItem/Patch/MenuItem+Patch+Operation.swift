import FeatherOpenAPI
import FeatherOpenAPIGenerator
import OpenAPIKit30
import WebOpenAPIGeneratorSupport

extension MenuItem.Patch {
    struct Operation: MenuItem.IdentifiableOperation, BearerProtectedOperation {
        var operationId: String? { "menuItemPatch" }
        var parameters: [any ParameterRepresentable] {
            [
                MenuItem.Parameters.MenuID().reference(),
                MenuItem.Parameters.ID().reference(),
                MenuItem.Parameters.UpdateMask().reference(),
            ]
        }
        var requestBody: (any RequestBodyRepresentable)? {
            MenuItemPatchRequestBody().reference()
        }

        var responseMap: ResponseMap {
            [
                200: MenuItemDetailResponse().reference(),
                400: DefaultHTTPErrorContentResponse(
                    description: "Bad Request"
                ),
                404: CustomResponse(description: "MenuItem not found"),
            ]
        }
    }
}
