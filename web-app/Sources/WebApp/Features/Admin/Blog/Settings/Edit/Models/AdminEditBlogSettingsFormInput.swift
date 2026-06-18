import Foundation

struct AdminEditBlogSettingsFormInput: Codable, Sendable, Equatable, Hashable {
    let postListPath: String
    let authorListPath: String
    let tagListPath: String
    let postPathPrefix: String
    let authorPathPrefix: String
    let tagPathPrefix: String

    var normalizedPostListPath: String {
        Self.normalize(postListPath)
    }

    var normalizedAuthorListPath: String {
        Self.normalize(authorListPath)
    }

    var normalizedTagListPath: String {
        Self.normalize(tagListPath)
    }

    var normalizedPostPathPrefix: String {
        Self.normalize(postPathPrefix)
    }

    var normalizedAuthorPathPrefix: String {
        Self.normalize(authorPathPrefix)
    }

    var normalizedTagPathPrefix: String {
        Self.normalize(tagPathPrefix)
    }

    func validationErrors() -> [String: String] {
        var result: [String: String] = [:]
        validate(
            normalizedPostListPath,
            key: BlogSettingsVariableKey.postListPath.fieldKey,
            label: BlogSettingsVariableKey.postListPath.label,
            errors: &result
        )
        validate(
            normalizedAuthorListPath,
            key: BlogSettingsVariableKey.authorListPath.fieldKey,
            label: BlogSettingsVariableKey.authorListPath.label,
            errors: &result
        )
        validate(
            normalizedTagListPath,
            key: BlogSettingsVariableKey.tagListPath.fieldKey,
            label: BlogSettingsVariableKey.tagListPath.label,
            errors: &result
        )
        validate(
            normalizedPostPathPrefix,
            key: BlogSettingsVariableKey.postPathPrefix.fieldKey,
            label: BlogSettingsVariableKey.postPathPrefix.label,
            errors: &result
        )
        validate(
            normalizedAuthorPathPrefix,
            key: BlogSettingsVariableKey.authorPathPrefix.fieldKey,
            label: BlogSettingsVariableKey.authorPathPrefix.label,
            errors: &result
        )
        validate(
            normalizedTagPathPrefix,
            key: BlogSettingsVariableKey.tagPathPrefix.fieldKey,
            label: BlogSettingsVariableKey.tagPathPrefix.label,
            errors: &result
        )
        return result
    }

    private func validate(
        _ value: String,
        key: String,
        label: String,
        errors: inout [String: String]
    ) {
        guard !value.isEmpty else { return }
        guard !value.contains("/") else {
            errors[key] = "\(label) must be a single path segment."
            return
        }
    }

    private static func normalize(
        _ value: String
    ) -> String {
        value
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .trimmingCharacters(in: CharacterSet(charactersIn: "/"))
    }
}
