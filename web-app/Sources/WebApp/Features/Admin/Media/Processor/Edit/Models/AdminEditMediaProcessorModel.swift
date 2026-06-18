import Foundation

struct AdminEditMediaProcessorModel: Sendable {
    let id: String
    let fileSuffix: String
    let matchExtensions: String
    let commandTemplate: String
    let error: String?
}
