import FeatherModuleKit
import SystemApplication
import SystemModule

enum FeatherVariableSeedEventHandlers {
    static func register(
        in events: inout EventRegistry
    ) {
        events.register(
            event: Variable.Event.Seed.self
        ) { _ in
            [
                .init(
                    key: "system-settings-mail-from-address",
                    value: "info@binarybirds.com",
                    name: "System mail from address",
                    notes: "Sender address for system-generated emails."
                ),
                .init(
                    key: "system-settings-mail-from-name",
                    value: "Binary Birds",
                    name: "System mail from name",
                    notes:
                        "Optional sender display name for system-generated emails."
                ),
            ]
        }
    }
}
