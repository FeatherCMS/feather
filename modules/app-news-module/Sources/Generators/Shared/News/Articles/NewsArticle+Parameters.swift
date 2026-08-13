import FeatherOpenAPI
import FeatherOpenAPIGenerator

public struct NewsArticleIdParameter: PathParameterRepresentable {
    public var name: String { "id" }
    public var description: String? { "News item identifier" }
    public var schema: any OpenAPISchemaRepresentable {
        NewsArticleIdField().reference()
    }

    public init() {}
}
