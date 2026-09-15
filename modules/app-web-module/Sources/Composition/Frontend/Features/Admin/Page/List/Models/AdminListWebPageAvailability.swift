import FeatherAdmin
import Foundation

enum AdminListWebPageAvailability: String, Sendable {
    case draft
    case scheduled
    case live
    case expired
    case archived

    init(
        metadata: AdminMetadataFormValue,
        at date: Date
    ) {
        switch metadata.normalizedStatus {
        case "draft":
            self = .draft
        case "archived":
            self = .archived
        case "published":
            guard
                let publicationTimestamp =
                    AdminMetadataSchemaBuilder.parseTimestamp(
                        metadata.normalizedPublicationDate
                    )
            else {
                self = .scheduled
                return
            }

            let publicationDate = Date(
                timeIntervalSince1970: publicationTimestamp
            )
            if publicationDate > date {
                self = .scheduled
            }
            else if let expirationTimestamp =
                AdminMetadataSchemaBuilder.parseTimestamp(
                    metadata.normalizedExpirationDate
                ),
                Date(timeIntervalSince1970: expirationTimestamp) <= date
            {
                self = .expired
            }
            else {
                self = .live
            }
        default:
            self = .draft
        }
    }

    var label: String {
        rawValue.capitalized
    }

    var color: NewAdminChip.ColorName {
        switch self {
        case .draft:
            return .yellow
        case .scheduled:
            return .blue
        case .live:
            return .green
        case .expired:
            return .orange
        case .archived:
            return .purple
        }
    }
}
