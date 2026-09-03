import FeatherAdmin
import Hummingbird

struct AdminGetDesignSystem {
    let controller: any AdminGetDesignSystemController

    init() {
        self.controller = AdminGetDesignSystemDefaultController()
    }
}
