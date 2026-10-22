import FeatherOpenAPI
import FeatherOpenAPIGenerator
import UserOpenAPIGeneratorSupport

extension Identity.Patch {
    struct Operation: Identity.IdentifiableOperation {
        var operationId: String? { "userIdentityPatch" }
        var parameters: [any ParameterRepresentable] {
            [
                IdentityIdParameter().reference(),
                Identity.Parameters.UpdateMask().reference(),
            ]
        }
        var requestBody: (any RequestBodyRepresentable)? {
            RequestBody().reference()
        }
        var responseMap: ResponseMap {
            [
                200: Identity.Get.Response().reference(),
                400: DefaultHTTPErrorContentResponse(
                    description: "Bad Request"
                ),
                404: DefaultHTTPErrorContentResponse(
                    description: "UserIdentity not found"
                ),
            ]
        }
    }

    struct RequestBody: RequestBodyRepresentable {
        var openAPIIdentifier: String { "UserIdentityPatchRequestBody" }
        var contentMap: ContentMap {
            [.json: Content(Schema().reference())]
        }
    }

    struct Schema: ObjectSchemaRepresentable {
        var openAPIIdentifier: String { "UserIdentityPatchSchema" }
        var propertyMap: SchemaMap {
            [
                "name": IdentityNameField().reference(required: false),
                "roleIds": Identity.Schemas.RoleIDs()
                    .reference(required: false),
                "status": IdentityStatusField().reference(required: false),
            ]
        }
    }
}
