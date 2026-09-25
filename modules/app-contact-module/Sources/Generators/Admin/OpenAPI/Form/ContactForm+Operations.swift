import FeatherOpenAPI
import FeatherOpenAPIGenerator
import OpenAPIKit30

protocol ContactFormOperation: BearerProtectedOperation {}
extension ContactFormOperation {
    var tags: [TagRepresentable] { [ContactFormsTag()] }
}
protocol ContactFormKeyOperation: ContactFormOperation {}
extension ContactFormKeyOperation {
    var parameters: [ParameterRepresentable] {
        [ContactFormKeyParameter().reference()]
    }
}

struct ContactFormListOperation: ContactFormOperation {
    var responseMap: ResponseMap {
        [200: ContactFormListResponse().reference()]
    }
}
struct ContactFormCreateOperation: ContactFormOperation {
    var requestBody: RequestBodyRepresentable? {
        ContactFormCreateRequestBody().reference()
    }
    var responseMap: ResponseMap { [201: ContactFormResponse().reference()] }
}
struct ContactFormGetOperation: ContactFormKeyOperation {
    var responseMap: ResponseMap {
        [
            200: ContactFormResponse().reference(),
            404: CustomResponse(description: "Contact form not found"),
        ]
    }
}
struct ContactFormUpdateOperation: ContactFormKeyOperation {
    var requestBody: RequestBodyRepresentable? {
        ContactFormCreateRequestBody().reference()
    }
    var responseMap: ResponseMap {
        [
            200: ContactFormResponse().reference(),
            404: CustomResponse(description: "Contact form not found"),
        ]
    }
}
struct ContactFormRemoveOperation: ContactFormOperation, DeleteOperation {}
