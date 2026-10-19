import FeatherOpenAPI
import FeatherOpenAPIGenerator
import OpenAPIKit30

extension Permission.Put {
    struct Operation: Permission.IdentifiableOperation, BearerProtectedOperation
    {
        var operationId: String? { "systemPermissionPut" }
        var requestBody: (any RequestBodyRepresentable)? {
            RequestBody().reference()
        }
        var responseMap: ResponseMap {
            [
                200: Permission.Get.Response().reference(),
                400: DefaultHTTPErrorContentResponse(
                    description: "Bad Request"
                ),
                404: DefaultHTTPErrorContentResponse(
                    description: "SystemPermission not found"
                ),
                409: DefaultHTTPErrorContentResponse(
                    description: "Permission key already exists"
                ),
            ]
        }
    }

    struct RequestBody: RequestBodyRepresentable {
        var openAPIIdentifier: String { "SystemPermissionPutRequestBody" }
        var contentMap: ContentMap {
            [.json: Content(Permission.Post.Schema().reference())]
        }
    }
}
