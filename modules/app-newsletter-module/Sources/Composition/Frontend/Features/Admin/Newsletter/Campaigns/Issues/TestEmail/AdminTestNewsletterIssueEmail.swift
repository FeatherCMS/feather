import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

struct AdminTestNewsletterIssueEmail {

    let controller: any AdminTestNewsletterIssueEmailController

    init(apiBuilder: NewsletterAPIBuilder) {
        controller = AdminTestNewsletterIssueEmailDefaultController(
            apiBuilder: apiBuilder
        )
    }
}
