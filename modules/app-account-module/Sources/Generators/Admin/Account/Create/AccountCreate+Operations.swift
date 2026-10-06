import FeatherOpenAPI
import FeatherOpenAPIGenerator
import OpenAPIKitCore

protocol AccountCreateOperation: BearerProtectedOperation {}

extension AccountCreateOperation {
    var tags: [any TagRepresentable] { [AccountCreateTag()] }
}

struct AccountCreateOperationDefinition: AccountCreateOperation {
    var requestBody: (any RequestBodyRepresentable)? {
        AccountCreateRequestBody().reference()
    }

    var responseMap: ResponseMap {
        [201: AccountCreateResponse().reference()]
    }
}
