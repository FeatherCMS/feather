import SystemModule
import SystemApplication

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
        case "auth.magic_link.email.template":
            return "{{email}} {{token}} {{url}}"
        case "system-settings-mail-from-address":
            return mailFromAddress
        case "system-settings-mail-from-name":
            return mailFromName
        case "web-settings-public-base-url":
            return value
        default:
            return nil
        }
    }
}
