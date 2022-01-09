//
//  RubyFuriAPISampleView.swift
//  KPAPIClient
//
//  Created by Chan, Paul | Paul | RP on 2022/01/10.
//

import SwiftUI
import Alamofire

struct RubyFuriAPISampleView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var textToAPI: String = ""
    @State private var APIResponseText: String = ""

    let session = KPAPISession(session: Session.default)
    
    var body: some View {
        VStack {
            TextField("文章を入力してください",     text: $textToAPI)
                .textFieldStyle(.roundedBorder)
                .border(.gray, width: 1)
                .padding(EdgeInsets(top: 5, leading: 5, bottom: 0, trailing: 5))
            
            Button("送信") {
                if textToAPI.isEmpty {
                    APIResponseText = "文章を入力してください"
                }
                else {
                    session.request(api: RubyFuriAPIRequest(text: textToAPI, grade: 1)) { result in
                        switch result {
                            case let .success(model):
                            APIResponseText = model.description
                            case let .failure(error):
                            APIResponseText = error.localizedDescription
                        }
                    }
                }
            }
            .frame(maxWidth: 70, maxHeight: 30)
            .buttonBorderShape(ButtonBorderShape.roundedRectangle)
            .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.blue, lineWidth:1))
            .padding(3)

            ScrollView {
                Text(APIResponseText)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .border(.black, width: 0.5)
            .padding(EdgeInsets(top: 0, leading: 5, bottom: 5, trailing: 5))
        }
        .navigationBarTitle(Text("RubyFuriAPISampleView"), displayMode: .inline)
        .navigationBarItems(
            leading: Button("戻る") {
                self.presentationMode.wrappedValue.dismiss()
            }
        )
        .navigationBarBackButtonHidden(true)
    }
}
