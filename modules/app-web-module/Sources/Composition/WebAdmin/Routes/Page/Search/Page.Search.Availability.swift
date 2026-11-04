import FeatherWebAdmin
import Foundation
import WebModule

extension Page.Search {
    enum StatusFilter: String, CaseIterable, Sendable {
        case draft
        case published
        case archived

        var label: String { rawValue.capitalized }
    }

    enum Availability: String, Sendable {
        case draft
        case scheduled
        case live
        case expired
        case archived

        var label: String {
            rawValue.capitalized
        }

        var color: AdminChip.ColorName {
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
}
