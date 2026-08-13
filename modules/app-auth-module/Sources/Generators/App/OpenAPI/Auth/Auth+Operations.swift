import AuthSharedOpenAPIGenerator
import FeatherOpenAPI
import FeatherOpenAPIGenerator
import OpenAPIKit30

struct AuthLoginOperation: OperationRepresentable {
    var requestBody: RequestBodyRepresentable? {
        AuthLoginRequestBody().reference()
    }

    var responseMap: ResponseMap {
        [200: AuthResponse().reference()]
    }
}

struct AuthLogoutOperation: OperationRepresentable, BearerProtectedOperation {
    var responseMap: ResponseMap {
        [204: CustomResponse(description: "Logged out")]
    }
}

struct AuthMagicLinkOperation: OperationRepresentable {
    var requestBody: RequestBodyRepresentable? {
        AuthMagicLinkRequestBody().reference()
    }

    var responseMap: ResponseMap {
        [204: CustomResponse(description: "Magic link requested")]
    }
}

struct AuthMagicLinkVerifyOperation: OperationRepresentable {
    var requestBody: RequestBodyRepresentable? {
        AuthMagicLinkVerifyRequestBody().reference()
    }

    var responseMap: ResponseMap {
        [200: AuthResponse().reference()]
    }
}

struct AuthMeOperation: OperationRepresentable, BearerProtectedOperation {
    var responseMap: ResponseMap {
        [200: AuthMeResponse().reference()]
    }
}
