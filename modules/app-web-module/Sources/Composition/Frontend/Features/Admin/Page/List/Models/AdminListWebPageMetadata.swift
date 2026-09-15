import Foundation

struct AdminListWebPageMetadata: Sendable {
    let slug: String
    let publicationDate: Double?
    let expirationDate: Double?
    let status: String

    var normalizedSlug: String {
        slug.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    var normalizedStatus: String {
        status
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .lowercased()
    }
}
