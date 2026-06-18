import FeatherOpenAPI
import OpenAPIKit30

public protocol AuthOperation: OperationRepresentable {

}

extension AuthOperation {
    public var tags: [TagRepresentable] { [AuthTag()] }
}

struct AuthLoginOperation: AuthOperation {

    var requestBody: RequestBodyRepresentable? {
        AuthLoginRequestBody().reference()
    }

    var responseMap: ResponseMap {
        [
            200: AuthResponse().reference()
        ]
    }
}

struct AuthLogoutOperation: AuthOperation, BearerProtectedOperation {

    var responseMap: ResponseMap {
        [
            204: CustomResponse(description: "Logged out")
        ]
    }
}

struct AuthMagicLinkOperation: AuthOperation {

    var requestBody: RequestBodyRepresentable? {
        AuthMagicLinkRequestBody().reference()
    }
    var responseMap: ResponseMap {
        [
            204: CustomResponse(description: "Magic link requested")
        ]
    }
}

struct AuthMagicLinkVerifyOperation: AuthOperation {

    var requestBody: RequestBodyRepresentable? {
        AuthMagicLinkVerifyRequestBody().reference()
    }

    var responseMap: ResponseMap {
        [
            200: AuthResponse().reference()
        ]
    }
}

struct AuthMeOperation: AuthOperation, BearerProtectedOperation {

    var responseMap: ResponseMap {
        [
            200: AuthMeResponse().reference()
        ]
    }
}
