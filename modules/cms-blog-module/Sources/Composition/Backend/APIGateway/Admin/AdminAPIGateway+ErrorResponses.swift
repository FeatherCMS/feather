import BlogAdminAPI
import FeatherDomain

extension AdminAPIGateway {
    func badRequestErrorEnvelope(
        reason: String
    ) -> Components.Schemas.DefaultHTTPErrorContentSchemaHTTPErrorEnvelopeSchema
    {
        .init(error: .init(message: "Bad Request", reason: reason))
    }

    func requiredFieldChange<Value: Sendable>(
        value: Value?,
        shouldApply: Bool
    ) -> FieldChange<Value>? {
        guard shouldApply else { return .unchanged }
        return value.map(FieldChange.set)
    }
}
