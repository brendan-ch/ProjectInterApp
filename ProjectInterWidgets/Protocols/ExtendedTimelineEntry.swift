//
//  ExtendedTimelineEntry.swift
//  ProjectInter
//
//  Created by Brendan Chen on 2025.10.08.
//

import WidgetKit

protocol ExtendedTimelineEntry: TimelineEntry {
    var status: TimelineEntryStatus { get }
}
