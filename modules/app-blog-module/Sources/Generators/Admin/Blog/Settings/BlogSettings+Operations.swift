import BlogSharedOpenAPIGenerator
public import FeatherOpenAPI
public import FeatherOpenAPIGenerator
import OpenAPIKit30

public protocol BlogSettingsOperation: BearerProtectedOperation {
}

extension BlogSettingsOperation {
    public var tags: [any TagRepresentable] { [BlogSettingsTag()] }
}

struct BlogSettingsGetOperation: BlogSettingsOperation {
    var responseMap: ResponseMap {
        [
            200: BlogSettingsDetailResponse().reference()
        ]
    }
}

struct BlogSettingsUpdateOperation: BlogSettingsOperation {
    var requestBody: (any RequestBodyRepresentable)? {
        BlogSettingsUpdateRequestBody().reference()
    }

    var responseMap: ResponseMap {
        [
            200: BlogSettingsDetailResponse().reference()
        ]
    }
}
