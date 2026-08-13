import BlogSharedOpenAPIGenerator
import FeatherOpenAPI
import FeatherOpenAPIGenerator
import OpenAPIKit30

public protocol BlogSettingsOperation: BearerProtectedOperation {
}

extension BlogSettingsOperation {
    public var tags: [TagRepresentable] { [BlogSettingsTag()] }
}

struct BlogSettingsGetOperation: BlogSettingsOperation {
    var responseMap: ResponseMap {
        [
            200: BlogSettingsDetailResponse().reference()
        ]
    }
}

struct BlogSettingsUpdateOperation: BlogSettingsOperation {
    var requestBody: RequestBodyRepresentable? {
        BlogSettingsUpdateRequestBody().reference()
    }

    var responseMap: ResponseMap {
        [
            200: BlogSettingsDetailResponse().reference()
        ]
    }
}
