import NewsletterApplication
import NewsletterModule

extension Campaign.Add {
    enum Interactor {}
}

extension Campaign.Add.Interactor {
    protocol Interface: Sendable {
        func get() async throws -> Campaign.Add.Model
        func add(payload: Campaign.Add.Form) async throws
            -> Campaign.Add.Model
    }
}
