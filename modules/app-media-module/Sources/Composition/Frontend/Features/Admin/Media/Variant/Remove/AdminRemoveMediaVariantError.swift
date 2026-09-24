enum AdminRemoveMediaVariantError: Error, Sendable {
    case notFound
    case unauthorized
    case forbidden
    case unavailable
}
