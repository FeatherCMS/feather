import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension Role.Patch {
    struct Operation: Role.IdentifiableOperation {
        var operationId: String? { "userRolePatch" }
        var parameters: [any ParameterRepresentable] {
            [
                Role.Parameters.ID().reference(),
                Role.Parameters.UpdateMask().reference(),
            ]
        }
        var requestBody: (any RequestBodyRepresentable)? {
            RequestBody().reference()
        }
        var responseMap: ResponseMap {
            [
                200: UserRoleDetailResponse().reference(),
                400: DefaultHTTPErrorContentResponse(description: "Bad Request"),
                404: DefaultHTTPErrorContentResponse(
                    description: "UserRole not found"
                ),
            ]
        }
    }

    struct RequestBody: RequestBodyRepresentable {
        var openAPIIdentifier: String { "UserRolePatchRequestBody" }
        var contentMap: ContentMap {
            [.json: Content(Schema().reference())]
        }
    }

    struct Schema: ObjectSchemaRepresentable {
        var openAPIIdentifier: String { "UserRolePatchSchema" }
        var propertyMap: SchemaMap {
            [
                "name": UserRoleNameField().nullable().reference(required: false),
                "notes": UserRoleNotesField().nullable().reference(required: false),
            ]
        }
    }
}
