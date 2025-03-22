import SwiftUI

struct TotalFeesView: View {
    @ObservedObject var viewModel: CreateDepositedGameViewModel
    let session: Session

    var body: some View {
        ZStack{
            VStack(spacing: 5) {
                Text("TOTAL")
                    .font(.custom("Poppins-SemiBold", size: 35))
                    .frame(maxWidth: .infinity, alignment: .center)
                
                VStack(alignment: .leading, spacing: 5) {
                    
                    HStack(){
                        Text("Total frais de dépôt :")
                            .font(.custom("Poppins-Light", size: 15))
                        Text("\(String(format: "%.2f", viewModel.totalDepositFee))€")
                            .font(.custom("Poppins-Light", size: 15))
                        Spacer()
                    }
                    
                    HStack(){
                        Text("Total réduction frais :")
                            .font(.custom("Poppins-Light", size: 15))
                        Text("\(String(format: "%.2f", viewModel.totalDiscount))€")
                            .font(.custom("Poppins-Light", size: 15))
                        Spacer()
                    }
                    
                    Spacer()
                    HStack(){
                        Spacer()
                        Text("Total à encaisser :")
                            .font(.custom("Poppins-SemiBold", size: 20))
                        Text("\(String(format: "%.2f", viewModel.totalAfterDiscount))€")
                            .font(.custom("Poppins-SemiBold", size: 20))
                    }
                }
                .padding()
                .frame(width: 340)
                .background(Color.white.opacity(0.5))
                .cornerRadius(20)
                .overlay(RoundedRectangle(cornerRadius: 20).stroke(Color.black, lineWidth: 1))
            }
            .onAppear {
                viewModel.initializeTotals(with: session) //Initialisation des totaux avec depositFee
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

