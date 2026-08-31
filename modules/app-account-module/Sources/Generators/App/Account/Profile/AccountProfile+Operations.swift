import AccountSharedOpenAPIGenerator
import FeatherOpenAPI
import FeatherOpenAPIGenerator
import OpenAPIKit30

protocol AccountProfileOperation: BearerProtectedOperation {}

extension AccountProfileOperation {
    var tags: [TagRepresentable] { [AccountTag()] }
}

struct AccountProfileGetOperation: AccountProfileOperation {
    var responseMap: ResponseMap {
        [200: AccountProfileResponse().reference()]
    }
}

struct AccountProfileUpdateOperation: AccountProfileOperation {
    var requestBody: RequestBodyRepresentable? {
        AccountProfileUpdateRequestBody().reference()
    }

    var responseMap: ResponseMap {
        [200: AccountProfileResponse().reference()]
    }
}
