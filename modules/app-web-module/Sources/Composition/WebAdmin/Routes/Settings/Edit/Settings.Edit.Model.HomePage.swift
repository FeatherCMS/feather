import FeatherModuleKit
import FeatherWebAdmin
import OpenAPIRuntime
import WebModule

extension Settings.Edit.Model {
    struct HomePage: Codable, Sendable, Equatable, Hashable {
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
}
