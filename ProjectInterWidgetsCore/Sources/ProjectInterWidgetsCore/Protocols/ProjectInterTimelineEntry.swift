//
//  ProjectInterTimelineEntry.swift
//  ProjectInter
//
//  Created by Brendan Chen on 2025.10.08.
//

import WidgetKit

/// Base timeline entry with shared properties.
public protocol ProjectInterTimelineEntry: TimelineEntry {
    var status: TimelineEntryStatus { get }
}
