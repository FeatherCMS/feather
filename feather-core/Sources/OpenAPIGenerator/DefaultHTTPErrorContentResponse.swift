public import FeatherOpenAPI

public struct DefaultHTTPErrorContentResponse: JSONResponseRepresentable {
    public var description: String
    public var schema = HTTPErrorEnvelopeSchema(
        error: DefaultHTTPErrorContentSchema()
    )
    .reference()

    public init(description: String = "HTTP error response") {
        self.description = description
    }
}
