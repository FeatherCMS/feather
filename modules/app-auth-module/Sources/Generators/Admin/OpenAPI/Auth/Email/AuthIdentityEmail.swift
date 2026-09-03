import AuthSharedOpenAPIGenerator
import FeatherOpenAPI
import FeatherOpenAPIGenerator
import OpenAPIKit30

struct AuthIdentityEmailIdField: StringSchemaRepresentable {
    var example: String? = "email_7nL3xQ2v"
}
struct AuthIdentityEmailIdentityIdField: StringSchemaRepresentable {
    var example: String? = "user_7nL3xQ2v"
}
struct AuthIdentityEmailEmailField: StringSchemaRepresentable {
    var example: String? = "john.doe@example.com"
    var format: String? = "email"
}
struct AuthIdentityEmailBooleanField: BoolSchemaRepresentable {}

struct AuthIdentityEmailCreateSchema: ObjectSchemaRepresentable {
    var propertyMap: SchemaMap {
        [
            "identityId": AuthIdentityEmailIdentityIdField(),
            "email": AuthIdentityEmailEmailField(),
            "isPrimary": AuthIdentityEmailBooleanField()
                .reference(required: false),
            "isVerified": AuthIdentityEmailBooleanField()
                .reference(required: false),
        ]
    }
}
struct AuthIdentityEmailPatchSchema: ObjectSchemaRepresentable {
    var propertyMap: SchemaMap {
        [
            "identityId": AuthIdentityEmailIdentityIdField()
                .reference(required: false),
            "email": AuthIdentityEmailEmailField().reference(required: false),
            "isPrimary": AuthIdentityEmailBooleanField()
                .reference(required: false),
            "isVerified": AuthIdentityEmailBooleanField()
                .reference(required: false),
        ]
    }
}
struct AuthIdentityEmailDetailSchema: ObjectSchemaRepresentable {
    var propertyMap: SchemaMap {
        [
            "id": AuthIdentityEmailIdField(),
            "identityId": AuthIdentityEmailIdentityIdField(),
            "email": AuthIdentityEmailEmailField(),
            "isPrimary": AuthIdentityEmailBooleanField(),
            "isVerified": AuthIdentityEmailBooleanField(),
        ]
    }
}
struct AuthIdentityEmailListSchema: ArraySchemaRepresentable {
    var items: SchemaRepresentable? {
        AuthIdentityEmailDetailSchema().reference()
    }
}
struct AuthIdentityEmailRequestBody: RequestBodyRepresentable {
    var contentMap: ContentMap {
        [.json: Content(AuthIdentityEmailCreateSchema().reference())]
    }
}
struct AuthIdentityEmailPatchRequestBody: RequestBodyRepresentable {
    var contentMap: ContentMap {
        [.json: Content(AuthIdentityEmailPatchSchema().reference())]
    }
}
struct AuthIdentityEmailDetailResponse: JSONResponseRepresentable {
    var description: String = "Auth identity email response"
    var schema = AuthIdentityEmailDetailSchema().reference()
}
struct AuthIdentityEmailListResponse: JSONResponseRepresentable {
    var description: String = "Auth identity email list response"
    var schema = AuthIdentityEmailListSchema().reference()
}
struct AuthIdentityEmailTag: TagRepresentable {
    var name: String = "AuthIdentityEmails"
}
struct AuthIdentityEmailIdParameter: PathParameterRepresentable {
    var name: String { "authIdentityEmailId" }
    var description: String? { nil }
    var schema: any OpenAPISchemaRepresentable {
        AuthIdentityEmailIdField().reference()
    }
}
protocol AuthIdentityEmailOperation: BearerProtectedOperation {}
extension AuthIdentityEmailOperation {
    var tags: [TagRepresentable] { [AuthIdentityEmailTag()] }
}
protocol AuthIdentityEmailIdOperation: AuthIdentityEmailOperation {}
extension AuthIdentityEmailIdOperation {
    var parameters: [ParameterRepresentable] {
        [AuthIdentityEmailIdParameter().reference()]
    }
}
struct AuthIdentityEmailPathItems: PathItemRepresentable {
    var post: OperationRepresentable? { AuthIdentityEmailCreateOperation() }
}
struct AuthIdentityEmailListPathItems: PathItemRepresentable {
    var get: OperationRepresentable? { AuthIdentityEmailListOperation() }
}
struct AuthIdentityEmailIdPathItems: PathItemRepresentable {
    var get: OperationRepresentable? { AuthIdentityEmailGetOperation() }
    var patch: OperationRepresentable? { AuthIdentityEmailPatchOperation() }
    var delete: OperationRepresentable? { AuthIdentityEmailDeleteOperation() }
}
struct AuthIdentityEmailCreateOperation: AuthIdentityEmailOperation {
    var requestBody: RequestBodyRepresentable? {
        AuthIdentityEmailRequestBody().reference()
    }
    var responseMap: ResponseMap {
        [201: AuthIdentityEmailDetailResponse().reference()]
    }
}
struct AuthIdentityEmailListOperation: AuthIdentityEmailOperation {
    var responseMap: ResponseMap {
        [200: AuthIdentityEmailListResponse().reference()]
    }
}
struct AuthIdentityEmailGetOperation: AuthIdentityEmailIdOperation {
    var responseMap: ResponseMap {
        [
            200: AuthIdentityEmailDetailResponse().reference(),
            404: CustomResponse(description: "Auth identity email not found"),
        ]
    }
}
struct AuthIdentityEmailPatchOperation: AuthIdentityEmailIdOperation {
    var requestBody: RequestBodyRepresentable? {
        AuthIdentityEmailPatchRequestBody().reference()
    }
    var responseMap: ResponseMap {
        [
            200: AuthIdentityEmailDetailResponse().reference(),
            404: CustomResponse(description: "Auth identity email not found"),
        ]
    }
}
struct AuthIdentityEmailDeleteOperation: AuthIdentityEmailIdOperation,
    DeleteOperation
{}
