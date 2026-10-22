import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension Author.Get {
    struct Operation: Author.ID.Operation {
        var operationId: String? { "blogAuthorGet" }
        var responseMap: ResponseMap {
            [
                200: BlogAuthorDetailResponse().reference(),
                404: CustomResponse(description: "Blog author not found"),
            ]
        }
    }
}
