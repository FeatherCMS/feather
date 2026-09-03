import AuthSharedOpenAPIGenerator
import FeatherOpenAPI
import FeatherOpenAPIGenerator
import OpenAPIKit30

struct AuthEmailIdField: StringSchemaRepresentable {
    var example: String? = "email_7nL3xQ2v"
}
struct AuthEmailIdentityIdField: StringSchemaRepresentable {
    var example: String? = "user_7nL3xQ2v"
}
struct AuthEmailEmailField: StringSchemaRepresentable {
    var example: String? = "john.doe@example.com"
    var format: String? = "email"
}
struct AuthEmailCreateSchema: ObjectSchemaRepresentable {
    var propertyMap: SchemaMap {
        [
            "identityId": AuthEmailIdentityIdField(),
            "email": AuthEmailEmailField(),
        ]
    }
}
struct AuthEmailPatchSchema: ObjectSchemaRepresentable {
    var propertyMap: SchemaMap {
        [
            "identityId": AuthEmailIdentityIdField()
                .reference(required: false),
            "email": AuthEmailEmailField().reference(required: false),
        ]
    }
}
struct AuthEmailDetailSchema: ObjectSchemaRepresentable {
    var propertyMap: SchemaMap {
        [
            "id": AuthEmailIdField(),
            "identityId": AuthEmailIdentityIdField(),
            "email": AuthEmailEmailField(),
        ]
    }
}
struct AuthEmailListSchema: ArraySchemaRepresentable {
    var items: SchemaRepresentable? {
        AuthEmailDetailSchema().reference()
    }
}
struct AuthEmailRequestBody: RequestBodyRepresentable {
    var contentMap: ContentMap {
        [.json: Content(AuthEmailCreateSchema().reference())]
    }
}
struct AuthEmailPatchRequestBody: RequestBodyRepresentable {
    var contentMap: ContentMap {
        [.json: Content(AuthEmailPatchSchema().reference())]
    }
}
struct AuthEmailDetailResponse: JSONResponseRepresentable {
    var description: String = "Auth auth email response"
    var schema = AuthEmailDetailSchema().reference()
}
struct AuthEmailListResponse: JSONResponseRepresentable {
    var description: String = "Auth auth email list response"
    var schema = AuthEmailListSchema().reference()
}
struct AuthEmailTag: TagRepresentable {
    var name: String = "AuthEmails"
}
struct AuthEmailIdParameter: PathParameterRepresentable {
    var name: String { "authEmailId" }
    var description: String? { nil }
    var schema: any OpenAPISchemaRepresentable {
        AuthEmailIdField().reference()
    }
}
protocol AuthEmailOperation: BearerProtectedOperation {}
extension AuthEmailOperation {
    var tags: [TagRepresentable] { [AuthEmailTag()] }
}
protocol AuthEmailIdOperation: AuthEmailOperation {}
extension AuthEmailIdOperation {
    var parameters: [ParameterRepresentable] {
        [AuthEmailIdParameter().reference()]
    }
}
struct AuthEmailPathItems: PathItemRepresentable {
    var post: OperationRepresentable? { AuthEmailCreateOperation() }
}
struct AuthEmailListPathItems: PathItemRepresentable {
    var get: OperationRepresentable? { AuthEmailListOperation() }
}
struct AuthEmailIdPathItems: PathItemRepresentable {
    var get: OperationRepresentable? { AuthEmailGetOperation() }
    var patch: OperationRepresentable? { AuthEmailPatchOperation() }
    var delete: OperationRepresentable? { AuthEmailDeleteOperation() }
}
struct AuthEmailCreateOperation: AuthEmailOperation {
    var requestBody: RequestBodyRepresentable? {
        AuthEmailRequestBody().reference()
    }
    var responseMap: ResponseMap {
        [201: AuthEmailDetailResponse().reference()]
    }
}
struct AuthEmailListOperation: AuthEmailOperation {
    var responseMap: ResponseMap {
        [200: AuthEmailListResponse().reference()]
    }
}
struct AuthEmailGetOperation: AuthEmailIdOperation {
    var responseMap: ResponseMap {
        [
            200: AuthEmailDetailResponse().reference(),
            404: CustomResponse(description: "Auth auth email not found"),
        ]
    }
}
struct AuthEmailPatchOperation: AuthEmailIdOperation {
    var requestBody: RequestBodyRepresentable? {
        AuthEmailPatchRequestBody().reference()
    }
    var responseMap: ResponseMap {
        [
            200: AuthEmailDetailResponse().reference(),
            404: CustomResponse(description: "Auth auth email not found"),
        ]
    }
}
struct AuthEmailDeleteOperation: AuthEmailIdOperation,
    DeleteOperation
{}
