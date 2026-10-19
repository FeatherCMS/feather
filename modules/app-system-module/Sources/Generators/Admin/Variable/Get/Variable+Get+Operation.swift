import FeatherOpenAPI
import FeatherOpenAPIGenerator
import OpenAPIKit30

extension Variable.Get {
    struct Operation: Variable.IdentifiableOperation, BearerProtectedOperation {
        var operationId: String? { "systemVariableGet" }
        var parameters: [any ParameterRepresentable] {
            [Variable.Parameters.ID().reference()]
        }
        var responseMap: ResponseMap {
            [
                200: Variable.Get.Response().reference(),
                404: DefaultHTTPErrorContentResponse(
                    description: "SystemVariable not found"
                ),
            ]
        }
    }
}
