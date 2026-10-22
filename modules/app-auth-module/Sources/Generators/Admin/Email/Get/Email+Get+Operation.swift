import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension Email.Get {
    struct Operation: Email.Operation {
        var operationId: String? { "authEmailGet" }

        var parameters: [any ParameterRepresentable] {
            [Email.Parameters.ID().reference()]
        }

        var responseMap: ResponseMap {
            [
                200: Response().reference(),
                404: CustomResponse(description: "Auth email not found"),
            ]
        }
    }
}
