import FeatherOpenAPI
import FeatherOpenAPIGenerator
import OpenAPIKit30

protocol ContactFieldOperation: ContactFormOperation {}
protocol ContactFieldIDOperation: ContactFieldOperation {}
extension ContactFieldIDOperation {
    var parameters: [any ParameterRepresentable] {
        [FormFieldIdParameter().reference()]
    }
}

struct ContactFieldListOperation: ContactFieldOperation {
    var responseMap: ResponseMap {
        [200: FormFieldListResponse().reference()]
    }
}
struct ContactFieldCreateOperation: ContactFieldOperation {
    var requestBody: (any RequestBodyRepresentable)? {
        FormFieldCreateRequestBody().reference()
    }
    var responseMap: ResponseMap {
        [201: FormFieldResponse().reference()]
    }
}
struct ContactFieldGetOperation: ContactFieldIDOperation {
    var responseMap: ResponseMap {
        [
            200: FormFieldResponse().reference(),
            404: CustomResponse(description: "Contact field not found"),
        ]
    }
}
struct ContactFieldUpdateOperation: ContactFieldIDOperation {
    var requestBody: (any RequestBodyRepresentable)? {
        FormFieldPatchRequestBody().reference()
    }
    var responseMap: ResponseMap {
        [
            200: FormFieldResponse().reference(),
            404: CustomResponse(description: "Contact field not found"),
        ]
    }
}
struct ContactFieldRemoveOperation: ContactFieldOperation,
    DeleteOperation
{}
