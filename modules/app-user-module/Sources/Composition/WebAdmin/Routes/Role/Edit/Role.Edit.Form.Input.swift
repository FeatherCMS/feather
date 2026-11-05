import FeatherModuleKit
import FeatherWebAdmin
import UserModule

extension Role.Edit.Form {
    public struct Input: Decodable, Sendable, Equatable,
        Hashable
    {

        public let name: String
        public let notes: String

        var normalizedName: String {
            name.whitespaceTrimmed
        }

        var normalizedNotes: String {
            notes.whitespaceTrimmed
        }
    }
}
