import FeatherOpenAPI
import FeatherOpenAPIGenerator

protocol AccountCreateOperation: BearerProtectedOperation {}

extension AccountCreateOperation {
    var tags: [TagRepresentable] { [AccountCreateTag()] }
}

struct AccountCreateOperationDefinition: AccountCreateOperation {
    var requestBody: RequestBodyRepresentable? {
        AccountCreateRequestBody().reference()
    }

    var responseMap: ResponseMap {
        [201: AccountCreateResponse().reference()]
    }
}
