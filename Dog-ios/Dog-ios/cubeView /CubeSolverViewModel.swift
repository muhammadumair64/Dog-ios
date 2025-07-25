import SceneKit
import Combine
import os.log
import SwiftUI

class CubeSolverViewModel: ObservableObject {
    @Published var rotationSequence: [String] = []
    @Published var solutionText: String = ""

    private var scene: SCNScene
    private var sceneKitView: SCNView?
    private var currentMoveIndex = 0
    private var moveTimer: Timer?

    var publicSceneKitView: SCNView? { sceneKitView }
    
    init(sceneKitView: SCNView) {
        self.sceneKitView = sceneKitView
        self.scene = SCNScene()
        setupScene()
    }
    
    private func setupScene() {
        sceneKitView?.scene = scene
        sceneKitView?.allowsCameraControl = true
        sceneKitView?.showsStatistics = false
        sceneKitView?.backgroundColor = UIColor(red: 30/255, green: 163/255, blue: 215/255, alpha: 1)

        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        cameraNode.position = SCNVector3(0, 0, 8)
        scene.rootNode.addChildNode(cameraNode)

        let ambientLightNode = SCNNode()
        ambientLightNode.light = SCNLight()
        ambientLightNode.light?.type = .ambient
        ambientLightNode.light?.color = UIColor.darkGray
        scene.rootNode.addChildNode(ambientLightNode)

        addRubiksCubeToScene()
    }
    
    private func addRubiksCubeToScene() {
        for x in -1...1 {
            for y in -1...1 {
                for z in -1...1 {
                    let cubeGeometry = SCNBox(width: 1, height: 1, length: 1, chamferRadius: 0.1)
                    cubeGeometry.materials = generateMaterialsForCubelet(x: x, y: y, z: z)

                    let cubeNode = SCNNode(geometry: cubeGeometry)
                    cubeNode.position = SCNVector3(x, y, z)
                    cubeNode.name = "cubelet_\(x)_\(y)_\(z)"
                    
                    scene.rootNode.addChildNode(cubeNode)
                }
            }
        }
    }

    private func generateMaterialsForCubelet(x: Int, y: Int, z: Int) -> [SCNMaterial] {
        let colors: [UIColor] = [.yellow, .green, .orange, .white, .red, .blue]
        return (0..<6).map { index in
            let material = SCNMaterial()
            material.diffuse.contents = colors[index]
            return material
        }
    }

    func solveCube(colors: [String]) async {
        guard let canonicalForm = prepareDataForSolver(colors: colors) else {
            DispatchQueue.main.async {
                self.solutionText = "Invalid configuration."
            }
            return
        }
        
        do {
            let solution = try await solveCubeWithConfiguration(canonicalForm)
            DispatchQueue.main.async {
                self.rotationSequence = solution.components(separatedBy: " ")
                self.solutionText = "Solving..."
                self.startExecutingMoves()
            }
        } catch {
            os_log("Error solving cube: %@", type: .error, error.localizedDescription)
        }
    }

    private func startExecutingMoves() {
        guard !rotationSequence.isEmpty else { return }

        currentMoveIndex = 0
        moveTimer?.invalidate()

        moveTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] timer in
            guard let self = self, self.currentMoveIndex < self.rotationSequence.count else {
                timer.invalidate()
                self?.solutionText = "Cube Solved!"
                return
            }
            
            let move = self.rotationSequence[self.currentMoveIndex]
            self.applyMove(move)
            self.currentMoveIndex += 1
        }
    }

    private func applyMove(_ move: String) {
        guard let node = scene.rootNode.childNode(withName: "cubelet_0_0_0", recursively: true) else { return }
        
        let action = SCNAction.rotateBy(x: 0, y: .pi / 2, z: 0, duration: 0.5)
        node.runAction(action)
        
        os_log("Applying move: %@", type: .info, move)
    }

    private func prepareDataForSolver(colors: [String]) -> String? {
        guard colors.count == 54 else { return nil }
        var configuration = ""
        
        let mapping: [String: String] = ["Y": "U", "G": "L", "O": "F", "B": "R", "W": "D", "R": "B"]
        for color in colors {
            configuration += mapping[color] ?? "X"
        }
        
        return configuration.contains("X") ? nil : configuration
    }

    private func solveCubeWithConfiguration(_ cubeConfiguration: String) async throws -> String {
        return await withCheckedContinuation { continuation in
            DispatchQueue.global(qos: .userInitiated).async {
                let solution = ApplyKociembaAlgorithm(cubeConfiguration)
                continuation.resume(returning: solution ?? "")
            }
        }
    }
}


extension SCNMaterial {
    static func create(with color: UIColor) -> SCNMaterial {
        let material = SCNMaterial()
        material.diffuse.contents = color
        return material
    }
}
