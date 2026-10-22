import SystemModule
import CSS
import AuthWebAdmin
import AuthModule
import FeatherWebAdmin
import FeatherModuleKit
import HTML
import SGML
import SystemWebAdmin
import Testing
import UserWebAdmin
import AccountWebAdmin
import AccountWebApp
@testable import WebModuleWebApp
@testable import WebModuleWebAdmin
import FeatherValidation

@testable import WebModuleWebApp

@Suite
struct WebAppTestSuite {

    @Test
    func authCredentialsMenuItemUsesRegisteredPermission() async throws {
        var events = EventRegistry()
        AuthAdminMenuEventHandlers.register(in: &events)

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

    @Test
    func loginFormInputValidationAcceptsValidPayload() async throws {
        let payload = LoginFormInput(
            email: "mail.tib@gmail.com",
            password: "password123",
            isPersistent: .init(value: true)
        )

        let failures = await payload.validationFailures()
        #expect(failures.isEmpty)
    }

    @Test
    func loginFormInputValidationRejectsInvalidEmail() async {
        let payload = LoginFormInput(
            email: "invalid-email",
            password: "password123",
            isPersistent: .init(value: false)
        )

        let failures = await payload.validationFailures()
        #expect(failures.first?.message == "Email is invalid.")
    }

    @Test
    func loginFormInputValidationRejectsShortPassword() async {
        let payload = LoginFormInput(
            email: "mail.tib@gmail.com",
            password: "",
            isPersistent: .init(value: false)
        )

        let failures = await payload.validationFailures()
        #expect(failures.first?.message == "The value is empty.")
    }

    @Test
    func userAccountFormInputValidationAcceptsValidPayload() async {
        let payload = AdminAddUserIdentityFormInput(
            status: "invited"
        )

        let failures = await payload.validationFailures()
        #expect(failures.isEmpty)
    }

    @Test
    func userAccountFormInputValidationRejectsInvalidEmail() async {
        let payload = AdminAddUserIdentityFormInput(
            status: " "
        )

        let failures = await payload.validationFailures()
        #expect(
            failures.contains(where: {
                $0.key == "status" && $0.message == "Status is required."
            })
        )
    }

    @Test
    func userAccountFormInputValidationRejectsEmptyPassword() async {
        let payload = AdminAddUserIdentityFormInput(
            status: ""
        )

        let failures = await payload.validationFailures()
        #expect(
            failures.contains(where: {
                $0.key == "status" && $0.message == "Status is required."
            })
        )
    }

    @Test
    func userRoleFormInputValidationRejectsEmptyName() async {
        let payload = AdminAddUserRoleFormInput(
            id: "role",
            name: " ",
            notes: "note"
        )
        let failures = await payload.validationFailures()
        #expect(failures.contains(where: { $0.key == "name" }))
    }

    @Test
    func accountInvitationFormInputValidationRejectsInvalidEmail() async {
        let payload = AdminAddAccountInvitationFormInput(email: "bad")
        let failures = await payload.validationFailures()
        #expect(failures.contains(where: { $0.key == "email" }))
    }

    @Test
    func systemPermissionFormInputValidationAcceptsEmptyNotes() async {
        let payload = SystemPermissionFormInput(name: "perm", notes: " ")
        let failures = await payload.validationFailures()
        #expect(failures.isEmpty)
    }

    @Test
    func webMenuItemPermissionValidationAcceptsEmptyPermission() {
        let payload = WebMenuItemFormInput(
            label: "Home",
            url: "/",
            priority: "0",
            isBlank: .init(value: false),
            permission: "",
            authentication: "any",
            notes: ""
        )

        #expect(
            payload.hasValidPermission(
                availablePermissions: ["web:pages:read"]
            )
        )
    }

    @Test
    func webMenuItemPermissionValidationRejectsUnknownPermission() {
        let payload = WebMenuItemFormInput(
            label: "Home",
            url: "/",
            priority: "0",
            isBlank: .init(value: false),
            permission: "web:pages:missing",
            authentication: "any",
            notes: ""
        )

        #expect(
            !payload.hasValidPermission(
                availablePermissions: ["web:pages:read"]
            )
        )
    }

    @Test
    func systemVariableFormInputValidationRejectsEmptyValue() async {
        let payload = SystemVariableFormInput(
            id: "variable",
            value: " ",
            name: "k",
            notes: "n"
        )
        let failures = await payload.validationFailures()
        #expect(failures.contains(where: { $0.key == "value" }))
    }

    @Test
    func userMagicLinkFormInputValidationRejectsInvalidEmail() async {
        let payload = AdminAddAuthMagicLinkFormInput(
            credentialId: "",
            isPersistent: .init(value: false)
        )
        let failures = await payload.validationFailures()
        #expect(failures.contains(where: { $0.key == "credential_id" }))
    }
}
