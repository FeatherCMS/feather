import Foundation

enum AdminListMediaVariantError: Error, Sendable {
    case unauthorized
    case forbidden
    case unavailable
}
