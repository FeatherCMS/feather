import AuthModule
import AuthWebAdmin
import FeatherModuleKit
import SystemWebAdmin
import Testing

@Suite
struct WebAppTestSuite {

    @Test
    func authCredentialsMenuItemUsesRegisteredPermission() async throws {
        var events = EventRegistry()
        AuthWebAdmin.Event.Handlers.registerMenu(in: &events)

        let items = try await events.trigger(
            event: SystemWebAdmin.Admin.Menu.Item.Provider(
                menuKey: "auth"
            ),
            using: SystemWebAdmin.Admin.Menu.Context(
                path: "/admin/auth/",
                permissions: []
            )
        )

        let credentials = items.flatMap { $0 }
            .first { $0.link == "/admin/auth/credentials/" }

        #expect(
            credentials?.permission == Credential.Permissions.list.rawValue
        )
    }
}
