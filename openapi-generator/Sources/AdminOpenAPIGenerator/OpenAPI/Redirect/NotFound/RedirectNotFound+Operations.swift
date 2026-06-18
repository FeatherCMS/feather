import FeatherOpenAPI
import OpenAPIKit30
import SharedOpenAPIComponents

protocol RedirectNotFoundOverviewBaseOperation: BearerProtectedOperation {}

extension RedirectNotFoundOverviewBaseOperation {
    var tags: [TagRepresentable] { [RedirectNotFoundTag()] }
}

struct RedirectNotFoundOverviewOperation: RedirectNotFoundOverviewBaseOperation
{
    var requestBody: RequestBodyRepresentable? {
        RedirectNotFoundOverviewRequestBody().reference()
    }

    var responseMap: ResponseMap {
        [
            200: RedirectNotFoundOverviewResponse().reference()
        ]
    }
}
