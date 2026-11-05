import Foundation

public enum AdminMetadataStatus: String, CaseIterable, Sendable {
    case draft
    case published
    case archived

    public var label: String { rawValue.capitalized }
}
