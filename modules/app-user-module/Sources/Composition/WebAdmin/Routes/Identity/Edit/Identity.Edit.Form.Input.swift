import FeatherModuleKit
import UserModule

extension Identity.Edit.Form {
    public struct Input: Decodable, Sendable, Equatable,
        Hashable
    {

        public let name: String
        public let status: String
        public let roleIds: [String]

        var normalizedStatus: String {
            status.whitespaceTrimmed
        }

        var normalizedName: String {
            name.whitespaceTrimmed
        }

    }
}
