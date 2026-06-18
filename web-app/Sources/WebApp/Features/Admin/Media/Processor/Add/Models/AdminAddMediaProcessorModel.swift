import Foundation

struct AdminAddMediaProcessorModel: Sendable {
    let fileSuffix: String
    let matchExtensions: String
    let commandTemplate: String
    let error: String?
}
