import Foundation

struct AdminEditWebSettingsHomePageModel:
    Codable,
    Sendable,
    Equatable,
    Hashable
{
    let id: String
    let title: String
    let slug: String

    var displayLabel: String {
        let normalizedSlug = slug.trimmingCharacters(
            in: .whitespacesAndNewlines
        )
        guard !normalizedSlug.isEmpty else {
            return title
        }
        return "\(title) (/\(normalizedSlug)/)"
    }
}
