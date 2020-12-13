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
//import AggregatorModule
import SponsorModule
import SwiftyModule
import MarkdownModule

let feather = try Feather()
defer { feather.stop() }

try feather.configureWithEnv(modules: [
                                FileBuilder(),
                                RedirectBuilder(),
                                BlogBuilder(),
                                AnalyticsBuilder(),
//                                AggregatorBuilder(),
                                SponsorBuilder(),
                                SwiftyBuilder(),
                                MarkdownBuilder(),
                      ])
try feather.start()
