import FeatherWebAdmin
import HTML
import Hummingbird
import NewsletterApplication
import NewsletterModule
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

extension Issue.Search {
    enum Interactor {
        protocol Interface: Sendable {
            func search(
                newsletterId: String,
                page: Int,
                search: String?
            ) async throws -> AdminListModel<Item>
        }
    }
}
