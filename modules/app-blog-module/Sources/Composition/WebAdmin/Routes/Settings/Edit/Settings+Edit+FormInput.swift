import BlogAdminAPI
import BlogAppAPI
import BlogModule
import FeatherModuleKit
import FeatherValidation
import FeatherWebAdmin
import Foundation
import HTML
import Hummingbird
import MediaWebAdmin
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents
import WebModuleWebAdmin

extension Settings.Edit {
    public struct FormInput: Codable, Sendable, Equatable, Hashable {
        public let postListPath: String
        public let authorListPath: String
        public let tagListPath: String
        public let postPathPrefix: String
        public let authorPathPrefix: String
        public let tagPathPrefix: String

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
                key: Settings.Edit.VariableKey.postListPath.fieldKey,
                label: Settings.Edit.VariableKey.postListPath.label,
                errors: &result
            )
            validate(
                normalizedAuthorListPath,
                key: Settings.Edit.VariableKey.authorListPath.fieldKey,
                label: Settings.Edit.VariableKey.authorListPath.label,
                errors: &result
            )
            validate(
                normalizedTagListPath,
                key: Settings.Edit.VariableKey.tagListPath.fieldKey,
                label: Settings.Edit.VariableKey.tagListPath.label,
                errors: &result
            )
            validate(
                normalizedPostPathPrefix,
                key: Settings.Edit.VariableKey.postPathPrefix.fieldKey,
                label: Settings.Edit.VariableKey.postPathPrefix.label,
                errors: &result
            )
            validate(
                normalizedAuthorPathPrefix,
                key: Settings.Edit.VariableKey.authorPathPrefix.fieldKey,
                label: Settings.Edit.VariableKey.authorPathPrefix.label,
                errors: &result
            )
            validate(
                normalizedTagPathPrefix,
                key: Settings.Edit.VariableKey.tagPathPrefix.fieldKey,
                label: Settings.Edit.VariableKey.tagPathPrefix.label,
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
                .whitespaceTrimmed
                .trimmingCharacters(in: CharacterSet(charactersIn: "/"))
        }
    }
}
