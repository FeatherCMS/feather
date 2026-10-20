import FeatherModuleKit
import FeatherWebAdmin
public import UserModule

extension Role.Edit {
    public struct FormInput: Decodable, Sendable, Equatable,
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
