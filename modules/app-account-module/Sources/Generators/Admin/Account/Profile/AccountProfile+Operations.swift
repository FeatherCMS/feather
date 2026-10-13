import AccountSharedOpenAPIGenerator
import FeatherOpenAPI
import FeatherOpenAPIGenerator
import OpenAPIKit30

protocol AdminAccountProfileOperation: BearerProtectedOperation {}

extension AdminAccountProfileOperation {
    var tags: [any TagRepresentable] { [AccountTag()] }
    var parameters: [any ParameterRepresentable] {
        [AccountProfileUserIDParameter().reference()]
    }
}

struct AdminAccountProfileGetOperation: AdminAccountProfileOperation {
    var responseMap: ResponseMap {
        [200: AccountProfileResponse().reference()]
    }
}

struct AdminAccountProfileUpdateOperation: AdminAccountProfileOperation {
    var requestBody: (any RequestBodyRepresentable)? {
        AccountProfileUpdateRequestBody().reference()
    }

    var responseMap: ResponseMap {
        [200: AccountProfileResponse().reference()]
    }
}
