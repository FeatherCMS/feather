//
//  File.swift
//  web-app
//
//  Addd by Tibor Bödecs on 2026. 03. 08..
//

import HTML
import Hummingbird
import SGML
import WebStandards

struct AdminGetAnalyticsHomeComponent: Component {

    func content() -> some BasicTag {
        Section {
            Nav {
                Ol {
                    Li { A("Admin").href("/admin/") }
                    Li("Analytics").ariaCurrent(.page)
                }
            }
            .class("cms-breadcrumb")
            .ariaLabel("Breadcrumb")

            H1("Analytics")
            P("Choose an analytics view or inspect the raw request logs.")
            Div {
                analyticsCard(
                    title: "Web",
                    description:
                        "Audience, referrers, browsers, languages, regions, and top pages.",
                    href: "/admin/analytics/web/"
                )
                analyticsCard(
                    title: "API",
                    description:
                        "Request volume, status families, top paths, methods, and failing routes.",
                    href: "/admin/analytics/api/"
                )
                analyticsCard(
                    title: "Logs",
                    description:
                        "Browse the tracked request log records directly.",
                    href: "/admin/analytics/logs/"
                )
            }
            .setAttribute(
                name: "style",
                value:
                    "display:grid;grid-template-columns:repeat(auto-fit,minmax(240px,1fr));gap:16px;margin-top:18px;"
            )
        }
        .class("cms-section")
    }

    private func analyticsCard(
        title: String,
        description: String,
        href: String
    ) -> some BasicTag {
        A {
            Strong(title)
            P(description)
                .setAttribute(
                    name: "style",
                    value: "margin:10px 0 0 0;color:inherit;"
                )
        }
        .href(href)
        .setAttribute(
            name: "style",
            value:
                "display:block;padding:18px;border:1px solid rgba(0,0,0,0.12);border-radius:12px;background:#fff;color:inherit;text-decoration:none;"
        )
    }
}
