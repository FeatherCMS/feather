public import FeatherOpenAPI
public import FeatherOpenAPIGenerator
import OpenAPIKit30

public protocol AuthOperation: OperationRepresentable {

}

extension AuthOperation {
    public var tags: [any TagRepresentable] { [AuthTag()] }
}

struct AuthLoginOperation: AuthOperation {

    var requestBody: (any RequestBodyRepresentable)? {
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

    var requestBody: (any RequestBodyRepresentable)? {
        AuthMagicLinkRequestBody().reference()
    }
    var responseMap: ResponseMap {
        [
            204: CustomResponse(description: "Magic link requested")
        ]
    }
}

struct AuthMagicLinkVerifyOperation: AuthOperation {

    var requestBody: (any RequestBodyRepresentable)? {
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
