import Foundation
import SwiftData

@Model
class LocationTask {
    var name: String
    var taskDescription: String
    var dueDate: Date
    var latitude: Double
    var longitude: Double

    init(name: String,
         taskDescription: String,
         dueDate: Date,
         latitude: Double,
         longitude: Double) {

        self.name = name
        self.taskDescription = taskDescription
        self.dueDate = dueDate
        self.latitude = latitude
        self.longitude = longitude
    }
}
