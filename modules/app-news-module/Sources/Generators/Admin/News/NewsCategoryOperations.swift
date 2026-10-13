import FeatherOpenAPI
import FeatherOpenAPIGenerator
import OpenAPIKit30

protocol NewsCategoryOperation: BearerProtectedOperation {}

extension NewsCategoryOperation {
    var tags: [TagRepresentable] { [NewsCategoryTag()] }
}

protocol NewsCategoryIDOperation: NewsCategoryOperation {}

extension NewsCategoryIDOperation {
    var parameters: [ParameterRepresentable] {
        [NewsCategoryIDParameter().reference()]
    }
}

struct NewsCategoryCreateOperation: NewsCategoryOperation {
    var requestBody: RequestBodyRepresentable? {
        NewsCategoryRequestBody().reference()
    }
    var responseMap: ResponseMap {
        [201: NewsCategoryDetailResponse().reference()]
    }
}

struct NewsCategoryListOperation: NewsCategoryOperation {
    var responseMap: ResponseMap {
        [200: NewsCategoryListResponse().reference()]
    }
}

struct NewsCategorySearchOperation: NewsCategoryOperation {
    var searchQuery: SearchQuerySchema {
        .init(
            items: NewsCategoryListItemSchema(),
            sortFieldKeys: ["id", "title", "createdAt", "updatedAt"],
            filters: SearchFilterSchema()
        )
    }

    var requestBody: RequestBodyRepresentable? {
        SearchRequestBody(query: searchQuery)
    }

    var responseMap: ResponseMap {
        [200: SearchResponse(query: searchQuery).reference()]
    }
}

struct NewsCategoryGetOperation: NewsCategoryIDOperation {
    var responseMap: ResponseMap {
        [
            200: NewsCategoryDetailResponse().reference(),
            404: CustomResponse(description: "News category not found"),
        ]
    }
}

struct NewsCategoryUpdateOperation: NewsCategoryIDOperation {
    var requestBody: RequestBodyRepresentable? {
        NewsCategoryUpdateRequestBody().reference()
    }
    var responseMap: ResponseMap {
        [
            200: NewsCategoryDetailResponse().reference(),
            404: CustomResponse(description: "News category not found"),
        ]
    }
}

struct NewsCategoryRemoveOperation: NewsCategoryOperation, DeleteOperation {}
