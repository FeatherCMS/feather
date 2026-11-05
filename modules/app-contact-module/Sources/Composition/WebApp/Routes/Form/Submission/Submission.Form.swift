import ContactModule
import Foundation

extension Submission {
    struct Form: Decodable, Sendable {
        let values: [String: String]
        let nonce: String?
        let redirect: String?
    }
}
