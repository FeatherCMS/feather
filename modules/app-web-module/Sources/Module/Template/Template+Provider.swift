public import Foundation

extension Template {
    public protocol Provider: Sendable {
        var templates: [Definition] { get }
        var bundledTemplatePaths: [URL] { get }
    }
}
