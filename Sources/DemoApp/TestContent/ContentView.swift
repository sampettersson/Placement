import SwiftUI
import Placement

struct ExpandingView: View {
    @State var expanded = false
    
    var body: some View {
        VStack(spacing: 0) {
            Color.yellow
                .frame(height: expanded ? 300 : 0)
            
            Button {
                withAnimation(.spring()) {
                    expanded.toggle()
                }
            } label: {
                Text("Button")
            }
        }
        .padding(EdgeInsets.init(top: 10, leading: 10, bottom: 10, trailing: 10))
    }
}

struct ContentView: View {
    @State var changePlacementThatFitsWidth = false
    @State var layout = OtherStack(shakeNumber: 200)
    
    var body: some View {
        ScrollView {
            PlacementThatFits(in: [.horizontal]) {
                HStack {
                    Text("1")
                    Text("ksklsddklsalksaddskladsaklsal")
                }
                Text("test")
            }
            .frame(maxWidth: changePlacementThatFitsWidth ? 150 : .infinity)
            
            Button("Change placement that fits width") {
                changePlacementThatFitsWidth.toggle()
                withAnimation(.spring()) {
                    layout.shakeNumber = layout.shakeNumber + 100
                }
            }
            
            layout {
                ExpandingView()
            }
            
            CenterLayoutView()
            
            Text("Hello")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
