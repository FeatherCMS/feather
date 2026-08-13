import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebStandards

protocol AdminAddNewsletterSubscriberInteractor: Sendable {
    func get() async throws -> AdminAddNewsletterSubscriberModel
    func post(form: AdminAddNewsletterSubscriberForm) async throws
        -> AdminAddNewsletterSubscriberModel
}
