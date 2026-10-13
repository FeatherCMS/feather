import FeatherAdmin
import FeatherContracts
import OpenAPIRuntime

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
        let normalizedSlug = slug.whitespaceTrimmed
        guard !normalizedSlug.isEmpty else {
            return title
        }
        return "\(title) (/\(normalizedSlug)/)"
    }
}
