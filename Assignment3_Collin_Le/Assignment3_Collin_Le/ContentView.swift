
import SwiftUI
import MapKit
import SwiftData

struct ContentView: View {
    
    @State private var cameraPosition: MapCameraPosition = .userLocation(
        followsHeading: false,
        fallback: .automatic
    )
    
    @State private var selectedCoordinate: CLLocationCoordinate2D?
    @State private var showingTaskSheet = false
    @Environment(\.modelContext) private var modelContext
    @Query private var tasks: [LocationTask]
    
    var body: some View {
        NavigationView {
            MapReader { proxy in
                Map(position: $cameraPosition) {
                    UserAnnotation()
                    
                    ForEach(tasks) { task in
                        Marker(
                            task.name,
                            coordinate: CLLocationCoordinate2D(
                                latitude: task.latitude,
                                longitude: task.longitude
                            )
                        )
                    }
                }
                .mapControls {
                    MapUserLocationButton()
                    MapCompass()
                    MapScaleView()
                }
                .simultaneousGesture(
                    LongPressGesture(minimumDuration: 0.7)
                        .sequenced(before: DragGesture(minimumDistance: 0))
                        .onEnded { value in
                            if case .second(true, let drag) = value,
                               let location = drag?.location,
                               let coordinate = proxy.convert(location, from: .local) {
                                
                                selectedCoordinate = coordinate
                                showingTaskSheet = true
                            }
                        }
                )
                .ignoresSafeArea(edges: .bottom)
                .navigationTitle("LocationTasks")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        NavigationLink(destination: TaskListView()) {
                            Text("View Tasks")
                        }
                    }
                }
                .sheet(isPresented: $showingTaskSheet) {
                    if let coordinate = selectedCoordinate {
                        TaskCreationView(coordinate: coordinate) { newTask in
                            modelContext.insert(newTask)
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
