//
//  main.swift
//  Feather
//
//  Created by Tibor Bodecs on 2019. 12. 17..
//

import FeatherCore

import FileModule
import RedirectModule
import BlogModule
import AnalyticsModule
import AggregatorModule
import SponsorModule
import SwiftyModule
import MarkdownModule

var env = try Environment.detect()
try LoggingSystem.bootstrap(from: &env)
let feather = try Feather(env: env)
defer { feather.stop() }

try feather.configureWithEnv(modules: [
                        FileBuilder(),
                        RedirectBuilder(),
                        BlogBuilder(),
                        AnalyticsBuilder(),
                        AggregatorBuilder(),
                        SponsorBuilder(),
                        SwiftyBuilder(),
                        MarkdownBuilder(),
                      ])
try feather.start()
