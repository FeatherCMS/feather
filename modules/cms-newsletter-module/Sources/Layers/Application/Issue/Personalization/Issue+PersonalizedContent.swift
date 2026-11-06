import Foundation
import NewsletterModule

extension Issue {
    enum PersonalizedContent {
        static func render(
            _ content: String,
            email: String,
            name: String
        ) -> String {
            content
                .replacingOccurrences(
                    of: "{{email}}",
                    with: htmlEscaped(email)
                )
                .replacingOccurrences(
                    of: "{{name}}",
                    with: htmlEscaped(name)
                )
        }

        static func renderSubject(
            _ subject: String,
            email: String,
            name: String
        ) -> String {
            subject
                .replacingOccurrences(
                    of: "{{email}}",
                    with: subjectSafe(email)
                )
                .replacingOccurrences(
                    of: "{{name}}",
                    with: subjectSafe(name)
                )
        }

        private static func subjectSafe(_ value: String) -> String {
            value
                .components(separatedBy: .newlines)
                .joined(separator: " ")
        }

        private static func htmlEscaped(_ value: String) -> String {
            value
                .replacingOccurrences(of: "&", with: "&amp;")
                .replacingOccurrences(of: "<", with: "&lt;")
                .replacingOccurrences(of: ">", with: "&gt;")
                .replacingOccurrences(of: "\"", with: "&quot;")
                .replacingOccurrences(of: "'", with: "&#39;")
        }
    }
}
