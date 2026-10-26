import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension Variable.Patch {
    struct Operation: Variable.IdentifiableOperation, BearerProtectedOperation {
        var operationId: String? { "systemVariablePatch" }
        var parameters: [any ParameterRepresentable] {
            [
                Variable.Parameters.ID().reference(),
                Variable.Parameters.UpdateMask().reference(),
            ]
        }
        var requestBody: (any RequestBodyRepresentable)? {
            RequestBody().reference()
        }
        var responseMap: ResponseMap {
            [
                200: Variable.Get.Response().reference(),
                400: DefaultHTTPErrorContentResponse(
                    description: "Bad Request"
                ),
                404: DefaultHTTPErrorContentResponse(
                    description: "SystemVariable not found"
                ),
                409: DefaultHTTPErrorContentResponse(
                    description: "Variable key already exists"
                ),
            ]
        }
    }

    struct RequestBody: RequestBodyRepresentable {
        var openAPIIdentifier: String { "SystemVariablePatchRequestBody" }
        var contentMap: ContentMap { [.json: Content(Schema().reference())] }
    }

    struct Schema: ObjectSchemaRepresentable {
        var openAPIIdentifier: String { "SystemVariablePatchSchema" }
        var propertyMap: SchemaMap {
            [
                "key": Variable.Schemas.Key().reference(required: false),
                "value": Variable.Schemas.Value().reference(required: false),
                "name": Variable.Schemas.Name().nullable()
                    .reference(
                        required: false
                    ),
                "notes": Variable.Schemas.Notes().nullable()
                    .reference(
                        required: false
                    ),
            ]
        }
    }
}
