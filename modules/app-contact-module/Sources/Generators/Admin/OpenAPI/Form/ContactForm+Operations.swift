import FeatherOpenAPI
import FeatherOpenAPIGenerator
import OpenAPIKit30

protocol ContactFormOperation: BearerProtectedOperation {}
extension ContactFormOperation {
    var tags: [TagRepresentable] { [ContactFormsTag()] }
}
protocol ContactFormIDOperation: ContactFormOperation {}
extension ContactFormIDOperation {
    var parameters: [ParameterRepresentable] {
        [ContactFormIdParameter().reference()]
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
struct ContactFormGetOperation: ContactFormIDOperation {
    var responseMap: ResponseMap {
        [
            200: ContactFormResponse().reference(),
            404: CustomResponse(description: "Contact form not found"),
        ]
    }
}
struct ContactFormUpdateOperation: ContactFormIDOperation {
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
struct ContactFormBulkDeleteOperation: ContactFormOperation, BulkDeleteOperation
{}
