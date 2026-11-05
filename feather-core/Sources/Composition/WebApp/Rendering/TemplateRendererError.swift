public import Foundation

public enum TemplateRendererError: Error, LocalizedError, Sendable {
    case missingTemplate(String)

    public var errorDescription: String? {
        switch self {
        case .missingTemplate(let template):
            return "Template not found: \(template)"
        }
    }
}
