import SystemApplication
import SystemModule

actor MockVariableLookup: SystemModule.Variable.Lookup.Interface {
    private let value: String?
    private let mailFromAddress: String
    private let mailFromName: String?

    init(
        value: String?,
        mailFromAddress: String = "configured@example.test",
        mailFromName: String? = nil
    ) {
        self.value = value
        self.mailFromAddress = mailFromAddress
        self.mailFromName = mailFromName
    }

    func get(_ id: String) async throws -> String? {
        switch id {
        case "system-settings-mail-from-address":
            mailFromAddress
        case "system-settings-mail-from-name":
            mailFromName
        case "web-settings-public-base-url":
            value
        default:
            nil
        }
    }
}
