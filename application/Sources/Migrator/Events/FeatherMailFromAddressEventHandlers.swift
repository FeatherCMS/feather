import FeatherContracts
import SystemApplication

enum FeatherMailFromAddressEventHandlers {
    static func register(
        in events: inout EventRegistry
    ) {
        events.register(
            event: MailFromAddressProvider.self,
            context: EventContext.self
        ) { _, _ in
            MailFromAddressProvider.Output(
                email: "info@binarybirds.com",
                name: "Binary Birds"
            )
        }
    }
}
