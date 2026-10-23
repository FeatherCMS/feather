import FeatherValidation
import FeatherWebAdmin
import FeatherWebShared
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

struct AdminTestNewsletterIssueEmail {

    let controller: any AdminTestNewsletterIssueEmailController

    init(environment: AppEnvironment) {
        controller = AdminTestNewsletterIssueEmailDefaultController(
            environment: environment
        )
    }
}
