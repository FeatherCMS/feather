import FeatherOpenAPI
import FeatherOpenAPIGenerator
import OpenAPIKit30

struct ContactFieldListOperation: ContactFieldOperation {
    var parameters: [any ParameterRepresentable] {
        [FormFieldListFilterParameter().reference()]
    }

    var responseMap: ResponseMap {
        [200: FormFieldListResponse().reference()]
    }
}
