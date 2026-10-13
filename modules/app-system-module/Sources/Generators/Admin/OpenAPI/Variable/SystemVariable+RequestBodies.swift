import FeatherOpenAPI
import OpenAPIKit30

struct SystemVariableRequestBody: RequestBodyRepresentable {
    var contentMap: ContentMap {
        [
            .json: Content(SystemVariableCreateSchema().reference())
        ]
    }
}

struct SystemVariableUpdateRequestBody: RequestBodyRepresentable {
    var contentMap: ContentMap {
        [
            .json: Content(SystemVariableCreateSchema().reference())
        ]
    }
}

struct SystemVariablePatchRequestBody: RequestBodyRepresentable {
    var contentMap: ContentMap {
        [
            .json: Content(SystemVariablePatchSchema().reference())
        ]
    }
}
