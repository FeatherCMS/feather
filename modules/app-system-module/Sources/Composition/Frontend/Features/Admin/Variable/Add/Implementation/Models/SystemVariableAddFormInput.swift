import FeatherContracts

public struct SystemVariableAddFormInput: Decodable, Sendable, Equatable, Hashable
{
    let key: String
    let value: String
    let name: String?
    let notes: String?

    init(
        key: String,
        value: String,
        name: String?,
        notes: String?
    ) {
        self.key = key
        self.value = value
        self.name = name
        self.notes = notes
    }

    var normalizedName: String? {
        name?.emptyToNil
    }

    var normalizedKey: String {
        key.emptyToNil ?? ""
    }

    var normalizedValue: String {
        value.emptyToNil ?? ""
    }

    var normalizedNotes: String? {
        notes?.emptyToNil
    }
}
