import Foundation

enum AdminListMediaVariantProcessorsError: Error, Sendable {
    case notFound
    case unauthorized
    case forbidden
    case unavailable
}
