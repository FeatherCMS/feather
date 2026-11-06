import BlogAppAPI

extension AppAPIGateway {
    func notFoundErrorEnvelope(
        message: String,
        reason: String
    )
        -> BlogAppAPI.Components.Schemas
        .DefaultHTTPErrorContentSchemaHTTPErrorEnvelopeSchema
    {
        .init(error: .init(message: message, reason: reason))
    }
}
