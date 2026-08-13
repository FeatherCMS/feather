import FeatherOpenAPI
import FeatherOpenAPIGenerator
import OpenAPIKit30

public protocol SystemJobOperation: BearerProtectedOperation {}

extension SystemJobOperation {
    public var tags: [TagRepresentable] { [SystemJobTag()] }
}

public protocol SystemJobIDOperation: SystemJobOperation {}

extension SystemJobIDOperation {
    public var parameters: [ParameterRepresentable] {
        [SystemJobIdParameter().reference()]
    }
}

struct SystemJobListOperation: SystemJobOperation {
    var responseMap: ResponseMap {
        [200: SystemJobListResponse().reference()]
    }
}

struct SystemJobGetOperation: SystemJobIDOperation {
    var responseMap: ResponseMap {
        [
            200: SystemJobResponse().reference(),
            404: CustomResponse(description: "Worker job not found"),
        ]
    }
}
