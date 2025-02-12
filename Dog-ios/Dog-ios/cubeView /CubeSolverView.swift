import SwiftUI
import SceneKit

struct CubeSolverView: View {
    @StateObject private var viewModel: CubeSolverViewModel

    init() {
        let sceneView = SCNView()
        _viewModel = StateObject(wrappedValue: CubeSolverViewModel(sceneKitView: sceneView))
    }

    var body: some View {
        VStack {
            SceneKitView(sceneKitView: viewModel.publicSceneKitView)
                .frame(height: 400)
            
            Button(action: {
                Task {
                    let shuffledColors = generateDummyColors()
                    await viewModel.solveCube(colors: shuffledColors)
                }
            }) {
                Text("Solve Cube Step by Step")
                    .font(.title)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            
            Text(viewModel.solutionText)
                .font(.title)
                .padding()
        }
    }
    
    func generateDummyColors() -> [String] {
        return [
            "Y", "G", "O", "W", "R", "B", "Y", "O", "G",
            "B", "W", "R", "G", "Y", "O", "R", "B", "W",
            "O", "Y", "G", "B", "W", "R", "Y", "O", "G",
            "W", "R", "B", "O", "G", "Y", "W", "R", "B",
            "G", "Y", "O", "R", "B", "W", "G", "Y", "O",
            "B", "W", "R", "Y", "O", "G", "W", "R", "B"
        ]
    }

}

struct SceneKitView: UIViewRepresentable {
    let sceneKitView: SCNView?

    func makeUIView(context: Context) -> SCNView {
        return sceneKitView ?? SCNView()
    }

    func updateUIView(_ uiView: SCNView, context: Context) {}
}

func ApplyKociembaAlgorithm(_ config: String) -> String? {
    // Call the Kociemba algorithm implemented in C++
    return "R U R' U R U2 R'" // Dummy steps
}
