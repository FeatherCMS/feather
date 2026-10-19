import FeatherOpenAPI
import FeatherOpenAPIGenerator
import OpenAPIKit30

protocol NewsCategoryOperation: BearerProtectedOperation {}

extension NewsCategoryOperation {
    var tags: [any TagRepresentable] { [NewsCategoryTag()] }
}

protocol NewsCategoryIDOperation: NewsCategoryOperation {}

extension NewsCategoryIDOperation {
    var parameters: [any ParameterRepresentable] {
        [NewsCategoryIDParameter().reference()]
    }
}

struct NewsCategoryCreateOperation: NewsCategoryOperation {
    var requestBody: (any RequestBodyRepresentable)? {
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
    var searchRequestQuery: SearchRequestQuerySchema {
        .init(
            items: NewsCategoryListItemSchema(),
            sortFieldKeys: ["id", "title", "createdAt", "updatedAt"],
            filters: SearchFilterSchema()
        )
    }

    var requestBody: (any RequestBodyRepresentable)? {
        SearchRequestBody(query: searchRequestQuery)
    }

    var responseMap: ResponseMap {
        [
            200: SearchResponse(
                query: SearchResponseQuerySchema(query: searchRequestQuery)
            )
            .reference()
        ]
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
    var requestBody: (any RequestBodyRepresentable)? {
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
