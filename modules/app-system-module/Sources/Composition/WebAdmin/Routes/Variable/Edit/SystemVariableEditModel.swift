import FeatherAdmin
import SystemModule

struct SystemVariableEditModel: Sendable {
    let id: String
    let key: String
    let value: String
    let name: String?
    let notes: String?
}
