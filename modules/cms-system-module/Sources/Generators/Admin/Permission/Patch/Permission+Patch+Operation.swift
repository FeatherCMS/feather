import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension Permission.Patch {
    struct Operation: Permission.IdentifiableOperation, BearerProtectedOperation
    {
        var operationId: String? { "systemPermissionPatch" }
        var parameters: [any ParameterRepresentable] {
            [
                Permission.Parameters.ID().reference(),
                Permission.Parameters.UpdateMask().reference(),
            ]
        }
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
        var openAPIIdentifier: String { "SystemPermissionPatchRequestBody" }
        var contentMap: ContentMap {
            [.json: Content(Schema().reference())]
        }
    }

    struct Schema: ObjectSchemaRepresentable {
        var openAPIIdentifier: String { "SystemPermissionPatchSchema" }
        var propertyMap: SchemaMap {
            [
                "key": Permission.Schemas.Key().reference(required: false),
                "name": Permission.Schemas.Name().nullable()
                    .reference(
                        required: false
                    ),
                "notes": Permission.Schemas.Notes().nullable()
                    .reference(
                        required: false
                    ),
            ]
        }
    }
}
