//
//  ReadVariable.swift
//  app-system-module
//
//  Created by Binary Birds on 2026. 06. 18.

import Application
import SystemDomain

public struct ReadVariable: Scope {
    public let variable: any VariableQueries

    public init(variable: any VariableQueries) {
        self.variable = variable
    }
}
