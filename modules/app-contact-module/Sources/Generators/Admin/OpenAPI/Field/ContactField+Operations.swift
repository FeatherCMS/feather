import FeatherOpenAPI
import FeatherOpenAPIGenerator
import OpenAPIKit30

protocol ContactFieldOperation: ContactFormOperation {}
protocol ContactFieldIDOperation: ContactFieldOperation {}
extension ContactFieldIDOperation {
    var parameters: [ParameterRepresentable] {
        [FormFieldIdParameter().reference()]
    }
}

protocol FormFieldOperation: ContactFormOperation {}
extension FormFieldOperation {
    var parameters: [ParameterRepresentable] {
        [ContactFormIdParameter().reference()]
    }
}
protocol FormFieldIDOperation: FormFieldOperation {}
extension FormFieldIDOperation {
    var parameters: [ParameterRepresentable] {
        [
            ContactFormIdParameter().reference(),
            FormFieldIdParameter().reference(),
        ]
    }
}

struct ContactFieldListOperation: ContactFieldOperation {
    var responseMap: ResponseMap {
        [200: FormFieldListResponse().reference()]
    }
}
struct ContactFieldCreateOperation: ContactFieldOperation {
    var requestBody: RequestBodyRepresentable? {
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
    var requestBody: RequestBodyRepresentable? {
        FormFieldPatchRequestBody().reference()
    }
    var responseMap: ResponseMap {
        [
            200: FormFieldResponse().reference(),
            404: CustomResponse(description: "Contact field not found"),
        ]
    }
}
struct ContactFieldDeleteOperation: ContactFieldOperation,
    DeleteOperation
{}

struct FormFieldListOperation: FormFieldOperation {
    var responseMap: ResponseMap {
        [200: FormFieldListResponse().reference()]
    }
}
struct FormFieldCreateOperation: FormFieldOperation {
    var requestBody: RequestBodyRepresentable? {
        FormFieldCreateRequestBody().reference()
    }
    var responseMap: ResponseMap {
        [201: FormFieldResponse().reference()]
    }
}
struct FormFieldGetOperation: FormFieldIDOperation {
    var responseMap: ResponseMap {
        [
            200: FormFieldResponse().reference(),
            404: CustomResponse(description: "Contact form field not found"),
        ]
    }
}
struct FormFieldUpdateOperation: FormFieldIDOperation {
    var requestBody: RequestBodyRepresentable? {
        FormFieldPatchRequestBody().reference()
    }
    var responseMap: ResponseMap {
        [
            200: FormFieldResponse().reference(),
            404: CustomResponse(description: "Contact form field not found"),
        ]
    }
}
struct FormFieldDeleteOperation: FormFieldOperation,
    DeleteOperation
{}
