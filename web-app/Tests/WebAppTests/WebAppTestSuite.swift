import CSS
import HTML
import SGML
import Testing

@testable import WebApp

@Suite
struct WebAppTestSuite {

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
        let payload = AdminAddUserAccountFormInput(
            email: "admin@feathercms.com",
            password: "password123"
        )

        let failures = await payload.validationFailures()
        #expect(failures.isEmpty)
    }

    @Test
    func userAccountFormInputValidationRejectsInvalidEmail() async {
        let payload = AdminAddUserAccountFormInput(
            email: "invalid-email",
            password: "pass123"
        )

        let failures = await payload.validationFailures()
        #expect(
            failures.contains(where: {
                $0.key == "email" && $0.message == "Email is invalid."
            })
        )
    }

    @Test
    func userAccountFormInputValidationRejectsEmptyPassword() async {
        let payload = AdminAddUserAccountFormInput(
            email: "admin@feathercms.com",
            password: " "
        )

        let failures = await payload.validationFailures()
        #expect(
            failures.contains(where: {
                $0.key == "password" && $0.message == "Password is required."
            })
        )
    }

    @Test
    func userRoleFormInputValidationRejectsEmptyName() async {
        let payload = AdminAddUserRoleFormInput(name: " ", notes: "note")
        let failures = await payload.validationFailures()
        #expect(failures.contains(where: { $0.key == "name" }))
    }

    @Test
    func userInvitationFormInputValidationRejectsInvalidEmail() async {
        let payload = AdminAddUserInvitationFormInput(email: "bad")
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
    func systemVariableFormInputValidationRejectsEmptyValue() async {
        let payload = SystemVariableFormInput(name: "k", value: " ", notes: "n")
        let failures = await payload.validationFailures()
        #expect(failures.contains(where: { $0.key == "value" }))
    }

    @Test
    func userMagicLinkFormInputValidationRejectsInvalidEmail() async {
        let payload = AdminAddUserMagicLinkFormInput(
            email: "bad",
            isPersistent: .init(value: false)
        )
        let failures = await payload.validationFailures()
        #expect(failures.contains(where: { $0.key == "email" }))
    }
}
