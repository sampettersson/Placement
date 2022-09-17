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
    @State var hello = false
    @State var layout = AnyPlacementLayout(OtherStack())
    
    var body: some View {
        ScrollView {
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
