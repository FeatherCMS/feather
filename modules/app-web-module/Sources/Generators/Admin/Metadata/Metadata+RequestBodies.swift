public import FeatherOpenAPI
import OpenAPIKit30
import WebOpenAPIGeneratorSupport

struct MetadataRequestBody: RequestBodyRepresentable {
    var contentMap: ContentMap {
        [
            .json: Content(MetadataCreateSchema().reference())
        ]
    }
}

struct MetadataUpdateRequestBody: RequestBodyRepresentable {
    var contentMap: ContentMap {
        [
            .json: Content(MetadataCreateSchema().reference())
        ]
    }
}

struct MetadataPatchRequestBody: RequestBodyRepresentable {
    var contentMap: ContentMap {
        [
            .json: Content(MetadataPatchSchema().reference())
        ]
    }
}

struct MetadataResolveRequestBody: RequestBodyRepresentable {
    var contentMap: ContentMap {
        [
            .json: Content(MetadataResolveRequestSchema().reference())
        ]
    }
}
