import FeatherAdmin
import HTML
import Hummingbird
import SGML
import WebBuilders
import WebComponents

struct AdminViewAccountOverviewComponent: Component {
    func html(context: inout RenderContext) -> some BasicTag {
        Section {
            Nav {
                Ol {
                    Li { A("Admin").href("/admin/") }
                    Li("Account").ariaCurrent(.page)
                }
            }
            .class("cms-breadcrumb")
            .ariaLabel("Breadcrumb")

            H1("Account module")
            Ul {
                Li {
                    A("Profile").href(
                        AccountAdminRoutes.profile.description + "/"
                    )
                }
                Li {
                    A("Settings").href(
                        AccountAdminRoutes.settings.description + "/"
                    )
                }
                Li {
                    A("Invitations").href(
                        AccountAdminRoutes.invitations.description + "/"
                    )
                }
            }
        }
        .class("cms-section")
    }
}
