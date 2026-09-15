import FeatherAdmin
import Foundation

enum AdminListWebPageAvailability: String, Sendable {
    case draft
    case scheduled
    case live
    case expired
    case archived

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
