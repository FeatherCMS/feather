import FeatherAdmin
import Foundation

struct AdminEditSettingsModel: Sendable {
    let language: String
    let timezone: String
    let pageSize: Int
}
