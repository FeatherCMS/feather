import FeatherOpenAPI
import FeatherOpenAPIGenerator
import OpenAPIKit30

public protocol MediaVariantOperation: BearerProtectedOperation {}

extension MediaVariantOperation {
    public var tags: [TagRepresentable] { [MediaVariantTag()] }
}

public protocol MediaVariantIDOperation: MediaVariantOperation {}

extension MediaVariantIDOperation {
    public var parameters: [ParameterRepresentable] {
        [MediaVariantIdParameter().reference()]
    }
}

public protocol MediaVariantProcessorIDOperation: MediaVariantIDOperation {}

extension MediaVariantProcessorIDOperation {
    public var parameters: [ParameterRepresentable] {
        [
            MediaVariantIdParameter().reference(),
            MediaVariantProcessorIdParameter().reference(),
        ]
    }
}

struct MediaVariantCreateOperation: MediaVariantOperation {
    var requestBody: RequestBodyRepresentable? { MediaVariantCreateRequestBody().reference() }
    var responseMap: ResponseMap { [201: MediaVariantDetailResponse().reference()] }
}

struct MediaVariantListOperation: MediaVariantOperation {
    var searchQuery: SearchQuerySchema { .init(items: MediaVariantListItemSchema(), sortFieldKeys: ["id", "key", "name", "isRequired", "isActive"], filters: SearchFilterSchema()) }
    var requestBody: RequestBodyRepresentable? { SearchRequestBody(query: searchQuery) }
    var responseMap: ResponseMap { [200: SearchResponse(query: searchQuery).reference()] }
}

struct MediaVariantGetOperation: MediaVariantIDOperation {
    var responseMap: ResponseMap { [200: MediaVariantDetailResponse().reference(), 404: CustomResponse(description: "Media variant not found")] }
}

struct MediaVariantUpdateOperation: MediaVariantIDOperation {
    var requestBody: RequestBodyRepresentable? { MediaVariantCreateRequestBody().reference() }
    var responseMap: ResponseMap { [200: MediaVariantDetailResponse().reference(), 404: CustomResponse(description: "Media variant not found")] }
}

struct MediaVariantRemoveOperation: MediaVariantOperation, DeleteOperation {}

struct MediaVariantProcessorCreateOperation: MediaVariantIDOperation {
    var requestBody: RequestBodyRepresentable? { MediaVariantProcessorCreateRequestBody().reference() }
    var responseMap: ResponseMap {
        [
            201: MediaVariantProcessorDetailResponse().reference(),
            404: CustomResponse(description: "Media variant not found"),
        ]
    }
}

struct MediaVariantProcessorListOperation: MediaVariantIDOperation {
    var searchQuery: SearchQuerySchema { .init(items: MediaVariantProcessorListItemSchema(), sortFieldKeys: ["id", "name", "matchExtensions", "commandTemplate", "isActive"], filters: SearchFilterSchema()) }
    var requestBody: RequestBodyRepresentable? { SearchRequestBody(query: searchQuery) }
    var responseMap: ResponseMap { [200: SearchResponse(query: searchQuery).reference()] }
}

struct MediaVariantProcessorGetOperation: MediaVariantProcessorIDOperation {
    var responseMap: ResponseMap {
        [
            200: MediaVariantProcessorDetailResponse().reference(),
            404: CustomResponse(description: "Media variant processor not found"),
        ]
    }
}

struct MediaVariantProcessorUpdateOperation: MediaVariantProcessorIDOperation {
    var requestBody: RequestBodyRepresentable? { MediaVariantProcessorCreateRequestBody().reference() }
    var responseMap: ResponseMap {
        [
            200: MediaVariantProcessorDetailResponse().reference(),
            404: CustomResponse(description: "Media variant processor not found"),
        ]
    }
}

struct MediaVariantProcessorRemoveOperation: MediaVariantIDOperation, DeleteOperation {}
