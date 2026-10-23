import ContactApplication
import ContactModule

extension Form.Add {
    struct Model: Sendable {
        let key: String
        let name: String
        let successMessage: String
        let failureMessage: String
        let redirectUrl: String?
        let fieldIDs: [String]
        let mails: [ContactForm.Email]
    }
}
