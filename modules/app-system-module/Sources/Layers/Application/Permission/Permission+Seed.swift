public import FeatherModuleKit
public import SystemModule

extension Permission {
    public struct Seed: Sendable, Hashable, Codable {
        public let key: String
        public let name: String?
        public let notes: String?

        public init(
            key: String,
            name: String? = nil,
            notes: String? = nil
        ) {
            self.key = key
            self.name = name
            self.notes = notes
        }

        public init(
            permission: PermissionKey,
            name: String? = nil,
            notes: String? = nil
        ) {
            self.init(
                key: permission.rawValue,
                name: name ?? permission.rawValue,
                notes: notes ?? permission.rawValue
            )
        }
    }
}
