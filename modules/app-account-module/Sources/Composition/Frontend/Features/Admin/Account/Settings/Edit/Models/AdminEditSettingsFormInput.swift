import FeatherAdmin
import Foundation

public struct AdminEditSettingsFormInput: Codable, Sendable, Equatable,
    Hashable
{
    public let language: String
    public let timezone: String
    public let pageSize: Int
}
