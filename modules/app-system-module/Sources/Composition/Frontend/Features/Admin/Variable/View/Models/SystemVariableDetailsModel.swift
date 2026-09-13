import FeatherAdmin
import Foundation

struct SystemVariableDetailsModel: Sendable {
    let id: String
    let key: String
    let value: String
    let name: String?
    let notes: String?
}
