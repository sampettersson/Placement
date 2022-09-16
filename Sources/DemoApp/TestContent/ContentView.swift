import SwiftUI
import Placement

struct ExpandingView: View {
    @State var expanded = false
    
    var body: some View {
        VStack(spacing: 0) {
            Button {
                withAnimation(.spring()) {
                    expanded.toggle()
                }
            } label: {
                Text("Button")
            }
                        
            Color.yellow
                .frame(height: expanded ? 300 : 0)
        }
        .padding(EdgeInsets.init(top: 10, leading: 10, bottom: 10, trailing: 10))
    }
}

struct ContentView: View {
    @State var hello = false
    @State var layout = AnyPlacementLayout(TestStack())
    
    var body: some View {
        ScrollView {
            layout {
                layout {
                    Color.green
                    Color.yellow
                }.frame(height: 100)
                layout {
                    Color.green
                    Color.yellow
                }.frame(height: 100)
            }
            .frame(height: hello ? 200 : 300)
            .background(Color.red)
            
            VStack(spacing: 0) {
                Button("Hello") {
                    withAnimation(.easeOut(duration: 0.3)) {
                        hello.toggle()
                        
                        if hello {
                            layout = AnyPlacementLayout(OtherStack())
                        } else {
                            layout = AnyPlacementLayout(TestStack())
                        }
                    }
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
