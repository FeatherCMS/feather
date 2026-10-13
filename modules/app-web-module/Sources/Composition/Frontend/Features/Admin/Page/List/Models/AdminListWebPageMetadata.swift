import FeatherContracts

struct AdminListWebPageMetadata: Sendable {
    let slug: String
    let publicationDate: Double?
    let expirationDate: Double?
    let status: String

    var normalizedSlug: String {
        slug.whitespaceTrimmed
    }

    var normalizedStatus: String {
        status
            .whitespaceTrimmed
            .lowercased()
    }
}
