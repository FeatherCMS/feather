import Hummingbird
import WebStandards

struct AppGetStylesheet {
    let controller: any AppGetStylesheetController

    init(globalStylesheetCollector: GlobalStylesheetCollector) {
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
}
