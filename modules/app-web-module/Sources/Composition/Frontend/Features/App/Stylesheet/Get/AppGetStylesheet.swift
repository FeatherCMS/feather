import FeatherAdmin
import Hummingbird
import OpenAPIRuntime
import WebStandards

public struct AppGetStylesheet {
    let controller: any AppGetStylesheetController

    public init(globalStylesheetCollector: GlobalStylesheetCollector) {
        self.controller = AppGetStylesheetDefaultController(
            buildRuntime: { _, _ in
                (
                    interactor: AppGetStylesheetDefaultInteractor(
                        globalStylesheetCollector: globalStylesheetCollector
                    ),
                    presenter: AppGetStylesheetDefaultPresenter()
                )
            }
        )
    }

    public func route(
        on router: Router<AppRequestContext>
    ) {
        controller.route(on: router)
    }
}
