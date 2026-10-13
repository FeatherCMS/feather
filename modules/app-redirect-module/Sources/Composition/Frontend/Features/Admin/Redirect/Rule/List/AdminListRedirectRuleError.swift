enum AdminListRedirectRuleError: Error, Sendable {
    case unauthorized
    case forbidden
    case unavailable
}
