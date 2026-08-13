import FeatherOpenAPI
import FeatherOpenAPIGenerator

public struct NewsCategoryIdParameter: PathParameterRepresentable {
    public var name: String { "id" }
    public var description: String? { "News category identifier" }
    public var schema: any OpenAPISchemaRepresentable {
        NewsCategoryIdField().reference()
    }

    public init() {}
}
