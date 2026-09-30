import AccountSharedOpenAPIGenerator
import FeatherOpenAPI
import FeatherOpenAPIGenerator
import OpenAPIKit30

protocol AccountProfileOperation: BearerProtectedOperation {}

extension AccountProfileOperation {
    var tags: [any TagRepresentable] { [AccountTag()] }
}

struct AccountProfileGetOperation: AccountProfileOperation {
    var responseMap: ResponseMap {
        [200: AccountProfileResponse().reference()]
    }
}

struct AccountProfileUpdateOperation: AccountProfileOperation {
    var requestBody: (any RequestBodyRepresentable)? {
        AccountProfileUpdateRequestBody().reference()
    }

    var responseMap: ResponseMap {
        [200: AccountProfileResponse().reference()]
    }
}
