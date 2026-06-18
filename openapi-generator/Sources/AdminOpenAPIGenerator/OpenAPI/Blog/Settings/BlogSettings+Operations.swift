import FeatherOpenAPI
import OpenAPIKit30
import SharedOpenAPIComponents

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
