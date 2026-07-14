import HTML
import SGML
import WebStandards

struct AdminContactFormTabs: Component, FlowContent {
    enum Tab { case details, emails, submissions }

    let formId: String
    let active: Tab

    func content() -> some BasicTag {
        Div {
            Style("""
                .admin-contact-form-tabs { display:flex; align-items:center; border:1px solid var(--cms-gray-3); border-radius:999px; margin-bottom:16px; padding:4px; gap:4px; width:100%; }
                .admin-contact-form-tabs a { flex:1; border:0; border-radius:999px; background:transparent; color:var(--cms-light-font); padding:8px 12px; line-height:1.2; text-align:center; cursor:pointer; text-decoration:none; }
                .admin-contact-form-tabs a:hover:not(.is-current) { color:var(--cms-link-hover); text-decoration:underline; }
                .admin-contact-form-tabs a.is-current { background:var(--cms-gray-4); color:var(--cms-strong-font); }
                """)
            A("Details").href("/admin/contact/forms/\(formId)/details/").if(active == .details) { $0.class("is-current") }
            A("Emails").href("/admin/contact/forms/\(formId)/emails/").if(active == .emails) { $0.class("is-current") }
            A("Submissions").href("/admin/contact/forms/\(formId)/submissions/").if(active == .submissions) { $0.class("is-current") }
        }
        .class("admin-media-asset-picker-tabs", "admin-contact-form-tabs")
    }
}
