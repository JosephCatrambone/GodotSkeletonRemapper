extends Node

var dt

func _ready():
	# If we happen to have a decision tree
	dt = DecisionTree.new()
	#dt.load_from_json('{"feature":0,"impurity_index":0.0240039300108791,"label_confidence":{"false":0.987800039674668,"true":0.0121999603253323},"left":{"feature":0,"impurity_index":0.0101220060064731,"label_confidence":{"false":0.994886705434129,"true":0.00511329456587127},"left":{"feature":0,"impurity_index":0,"label_confidence":{"false":1},"left":null,"right":null,"threshold":0},"right":{"feature":5,"impurity_index":0.020176142013848,"label_confidence":{"false":0.989773410868257,"true":0.0102265891317425},"left":{"feature":15,"impurity_index":0.0314726609387388,"label_confidence":{"false":0.983942191890807,"true":0.0160578081091931},"left":{"feature":0,"impurity_index":0,"label_confidence":{"false":1},"left":null,"right":null,"threshold":0},"right":{"feature":8,"impurity_index":0.0390388384376361,"label_confidence":{"false":0.97997997997998,"true":0.02002002002002},"left":{"feature":5,"impurity_index":0.0197107642137984,"label_confidence":{"false":0.98997995991984,"true":0.0100200400801603},"left":{"feature":8,"impurity_index":0.0351533695362523,"label_confidence":{"false":0.981963927855711,"true":0.0180360721442886},"left":{"feature":13,"impurity_index":0.00922282341367437,"label_confidence":{"false":0.995327102803738,"true":0.00467289719626168},"left":{"feature":0,"impurity_index":0.025375939849624,"label_confidence":{"false":0.986842105263158,"true":0.0131578947368421},"left":{"feature":11,"impurity_index":0.0571428571428571,"label_confidence":{"false":0.964285714285714,"true":0.0357142857142857},"left":{"feature":4,"impurity_index":0.2,"label_confidence":{"false":0.8,"true":0.2},"left":null,"right":null,"threshold":-0.00984926964156},"right":{"feature":0,"impurity_index":0,"label_confidence":{"false":1},"left":null,"right":null,"threshold":0},"threshold":0.0217492012307048},"right":{"feature":0,"impurity_index":0,"label_confidence":{"false":1},"left":null,"right":null,"threshold":0},"threshold":-0.36102219695681},"right":{"feature":0,"impurity_index":0,"label_confidence":{"false":1},"left":null,"right":null,"threshold":0},"threshold":-0.0027320476056},"right":{"feature":13,"impurity_index":0.054001670843776,"label_confidence":{"false":0.971929824561404,"true":0.0280701754385965},"left":{"feature":13,"impurity_index":0.0727861319966584,"label_confidence":{"false":0.961904761904762,"true":0.0380952380952381},"left":{"feature":14,"impurity_index":0.0390625,"label_confidence":{"false":0.979166666666667,"true":0.0208333333333333},"left":{"feature":0,"impurity_index":0,"label_confidence":{"false":1},"left":null,"right":null,"threshold":0},"right":{"feature":12,"impurity_index":0.105769230769231,"label_confidence":{"false":0.9375,"true":0.0625},"left":null,"right":null,"threshold":-0.011985790938},"threshold":0.00831760068892421},"right":{"feature":14,"impurity_index":0.096728307254623,"label_confidence":{"false":0.947368421052632,"true":0.0526315789473684},"left":{"feature":2,"impurity_index":0.143170197224251,"label_confidence":{"false":0.918918918918919,"true":0.0810810810810811},"left":null,"right":null,"threshold":0.0117111159488559},"right":{"feature":0,"impurity_index":0,"label_confidence":{"false":1},"left":null,"right":null,"threshold":0},"threshold":0.0147407469388894},"threshold":0.0123211446740859},"right":{"feature":0,"impurity_index":0,"label_confidence":{"false":1},"left":null,"right":null,"threshold":0},"threshold":0.0164184308147156},"threshold":-0.0042804437565},"right":{"feature":8,"impurity_index":0.00397569332212811,"label_confidence":{"false":0.997995991983968,"true":0.00200400801603206},"left":{"feature":13,"impurity_index":0.0157998683344306,"label_confidence":{"false":0.991935483870968,"true":0.00806451612903226},"left":{"feature":2,"impurity_index":0.0388726919339164,"label_confidence":{"false":0.979591836734694,"true":0.0204081632653061},"left":{"feature":0,"impurity_index":0,"label_confidence":{"false":1},"left":null,"right":null,"threshold":0},"right":{"feature":1,"impurity_index":0.0857142857142857,"label_confidence":{"false":0.952380952380952,"true":0.0476190476190476},"left":{"feature":3,"impurity_index":0.15,"label_confidence":{"false":0.9,"true":0.1},"left":null,"right":null,"threshold":0.00400119358673692},"right":{"feature":0,"impurity_index":0,"label_confidence":{"false":1},"left":null,"right":null,"threshold":0},"threshold":0.151413381099701},"threshold":0.0315761890139699},"right":{"feature":0,"impurity_index":0,"label_confidence":{"false":1},"left":null,"right":null,"threshold":0},"threshold":-0.01351351351351},"right":{"feature":0,"impurity_index":0,"label_confidence":{"false":1},"left":null,"right":null,"threshold":0},"threshold":-0.00229819707851},"threshold":-0.00023673495161},"right":{"feature":4,"impurity_index":0.0577826086956522,"label_confidence":{"false":0.97,"true":0.03},"left":{"feature":11,"impurity_index":0.032391079344621,"label_confidence":{"false":0.983333333333333,"true":0.0166666666666667},"left":{"feature":11,"impurity_index":0.0116131172924846,"label_confidence":{"false":0.994082840236686,"true":0.00591715976331361},"left":{"feature":3,"impurity_index":0.0355140186915888,"label_confidence":{"false":0.981308411214953,"true":0.0186915887850467},"left":{"feature":8,"impurity_index":0.0882352941176471,"label_confidence":{"false":0.95,"true":0.05},"left":{"feature":0,"impurity_index":0,"label_confidence":{"false":1},"left":null,"right":null,"threshold":0},"right":{"feature":15,"impurity_index":0.168067226890756,"label_confidence":{"false":0.882352941176471,"true":0.117647058823529},"left":null,"right":null,"threshold":1},"threshold":0.00448714452729114},"right":{"feature":0,"impurity_index":0,"label_confidence":{"false":1},"left":null,"right":null,"threshold":0},"threshold":-0.00312582646522},"right":{"feature":0,"impurity_index":0,"label_confidence":{"false":1},"left":null,"right":null,"threshold":0},"threshold":-0.00802563268637},"right":{"feature":12,"impurity_index":0.0645034800509754,"label_confidence":{"false":0.965346534653465,"true":0.0346534653465347},"left":{"feature":14,"impurity_index":0.126780970780005,"label_confidence":{"false":0.930693069306931,"true":0.0693069306930693},"left":{"feature":0,"impurity_index":0,"label_confidence":{"false":1},"left":null,"right":null,"threshold":0},"right":{"feature":13,"impurity_index":0.151721664275466,"label_confidence":{"false":0.914634146341463,"true":0.0853658536585366},"left":{"feature":12,"impurity_index":0.207407407407407,"label_confidence":{"false":0.875,"true":0.125},"left":null,"right":null,"threshold":-0.02662957074722},"right":{"feature":13,"impurity_index":0.0294117647058824,"label_confidence":{"false":0.970588235294118,"true":0.0294117647058824},"left":null,"right":null,"threshold":0},"threshold":-0.00986854860599},"threshold":-0.00119236883943},"right":{"feature":0,"impurity_index":0,"label_confidence":{"false":1},"left":null,"right":null,"threshold":0},"threshold":0.0075516693163752},"threshold":0.000515410586944267},"right":{"feature":5,"impurity_index":0.0850094517958413,"label_confidence":{"false":0.954347826086957,"true":0.0456521739130435},"left":{"feature":7,"impurity_index":0.0252717391304348,"label_confidence":{"false":0.98695652173913,"true":0.0130434782608696},"left":{"feature":0,"impurity_index":0,"label_confidence":{"false":1},"left":null,"right":null,"threshold":0},"right":{"feature":12,"impurity_index":0.0572916666666667,"label_confidence":{"false":0.96875,"true":0.03125},"left":{"feature":0,"impurity_index":0.128205128205128,"label_confidence":{"false":0.916666666666667,"true":0.0833333333333333},"left":{"feature":0,"impurity_index":0,"label_confidence":{"false":1},"left":null,"right":null,"threshold":0},"right":{"feature":8,"impurity_index":0.184615384615385,"label_confidence":{"false":0.769230769230769,"true":0.230769230769231},"left":null,"right":null,"threshold":0.00899621139755101},"threshold":-0.52705892312399},"right":{"feature":0,"impurity_index":0,"label_confidence":{"false":1},"left":null,"right":null,"threshold":0},"threshold":0.0511352344992051},"threshold":-0.00096250968789},"right":{"feature":0,"impurity_index":0.136862003780718,"label_confidence":{"false":0.921739130434783,"true":0.0782608695652174},"left":{"feature":0,"impurity_index":0.210489492096057,"label_confidence":{"false":0.860869565217391,"true":0.139130434782609},"left":{"feature":1,"impurity_index":0.0335621662852784,"label_confidence":{"false":0.982456140350877,"true":0.0175438596491228},"left":{"feature":0,"impurity_index":0,"label_confidence":{"false":1},"left":null,"right":null,"threshold":0},"right":{"feature":12,"impurity_index":0.0745341614906832,"label_confidence":{"false":0.956521739130435,"true":0.0434782608695652},"left":null,"right":null,"threshold":-0.02543720190779},"threshold":-0.12252760770028},"right":{"feature":0,"impurity_index":0.324146170642277,"label_confidence":{"false":0.741379310344828,"true":0.258620689655172},"left":{"feature":3,"impurity_index":0.473118279569893,"label_confidence":{"false":0.580645161290323,"true":0.419354838709677},"left":null,"right":null,"threshold":-0.00000000185566},"right":{"feature":0,"impurity_index":0.125356125356125,"label_confidence":{"false":0.925925925925926,"true":0.0740740740740741},"left":null,"right":null,"threshold":-0.51994889974594},"threshold":-0.5279625520624},"threshold":-0.54719603061676},"right":{"feature":0,"impurity_index":0.032,"label_confidence":{"false":0.982608695652174,"true":0.0173913043478261},"left":{"feature":0,"impurity_index":0,"label_confidence":{"false":1},"left":null,"right":null,"threshold":0},"right":{"feature":7,"impurity_index":0.12,"label_confidence":{"false":0.92,"true":0.08},"left":{"feature":0,"impurity_index":0,"label_confidence":{"false":1},"left":null,"right":null,"threshold":0},"right":{"feature":3,"impurity_index":0.166666666666667,"label_confidence":{"false":0.75,"true":0.25},"left":null,"right":null,"threshold":-0.0103577901121},"threshold":-0.00726048767278},"threshold":-0.39084571350001},"threshold":-0.50172263383865},"threshold":-0.00007144700794},"threshold":0.00153691607868495},"threshold":0.00000000156462191119866},"threshold":0},"right":{"feature":5,"impurity_index":0.00874711287114474,"label_confidence":{"false":0.995592948717949,"true":0.00440705128205128},"left":{"feature":8,"impurity_index":0.00354529707901286,"label_confidence":{"false":0.998212157330155,"true":0.00178784266984505},"left":{"feature":3,"impurity_index":0.0166329421286928,"label_confidence":{"false":0.991501416430595,"true":0.0084985835694051},"left":{"feature":16,"impurity_index":0.0404312668463612,"label_confidence":{"false":0.978571428571429,"true":0.0214285714285714},"left":{"feature":12,"impurity_index":0.0990566037735849,"label_confidence":{"false":0.943396226415094,"true":0.0566037735849057},"left":{"feature":0,"impurity_index":0,"label_confidence":{"false":1},"left":null,"right":null,"threshold":0},"right":{"feature":0,"impurity_index":0.196428571428571,"label_confidence":{"false":0.875,"true":0.125},"left":{"feature":0,"impurity_index":0,"label_confidence":{"false":1},"left":null,"right":null,"threshold":0},"right":{"feature":12,"impurity_index":0.267857142857143,"label_confidence":{"false":0.785714285714286,"true":0.214285714285714},"left":{"feature":7,"impurity_index":0.366666666666667,"label_confidence":{"false":0.625,"true":0.375},"left":null,"right":null,"threshold":-0.00952728185803},"right":{"feature":0,"impurity_index":0,"label_confidence":{"false":1},"left":null,"right":null,"threshold":0},"threshold":0.0214342493754258},"threshold":-0.00000001871789},"threshold":-0.02236254012059},"right":{"feature":0,"impurity_index":0,"label_confidence":{"false":1},"left":null,"right":null,"threshold":0},"threshold":1},"right":{"feature":0,"impurity_index":0,"label_confidence":{"false":1},"left":null,"right":null,"threshold":0},"threshold":-0.00235950039716},"right":{"feature":0,"impurity_index":0,"label_confidence":{"false":1},"left":null,"right":null,"threshold":0},"threshold":-0.00047261225758},"right":{"feature":15,"impurity_index":0.0192848947881799,"label_confidence":{"false":0.990220048899755,"true":0.0097799511002445},"left":{"feature":0,"impurity_index":0,"label_confidence":{"false":1},"left":null,"right":null,"threshold":0},"right":{"feature":16,"impurity_index":0.0275851704661677,"label_confidence":{"false":0.985940246045694,"true":0.0140597539543058},"left":{"feature":4,"impurity_index":0.0370436365811894,"label_confidence":{"false":0.980997624703088,"true":0.0190023752969121},"left":{"feature":5,"impurity_index":0.0173743606397662,"label_confidence":{"false":0.991150442477876,"true":0.00884955752212389},"left":{"feature":0,"impurity_index":0,"label_confidence":{"false":1},"left":null,"right":null,"threshold":0},"right":{"feature":6,"impurity_index":0.035338090383962,"label_confidence":{"false":0.981651376146789,"true":0.018348623853211},"left":{"feature":12,"impurity_index":0.0679012345679013,"label_confidence":{"false":0.962962962962963,"true":0.037037037037037},"left":{"feature":0,"impurity_index":0,"label_confidence":{"false":1},"left":null,"right":null,"threshold":0},"right":{"feature":5,"impurity_index":0.119047619047619,"label_confidence":{"false":0.916666666666667,"true":0.0833333333333333},"left":null,"right":null,"threshold":0.00698041772183129},"threshold":-0.01263027733616},"right":{"feature":0,"impurity_index":0,"label_confidence":{"false":1},"left":null,"right":null,"threshold":0},"threshold":0.00223905593156815},"threshold":0.00584626211594793},"right":{"feature":5,"impurity_index":0.0577319587628866,"label_confidence":{"false":0.969230769230769,"true":0.0307692307692308},"left":{"feature":0,"impurity_index":0.098115890508354,"label_confidence":{"false":0.938144329896907,"true":0.0618556701030928},"left":{"feature":0,"impurity_index":0,"label_confidence":{"false":1},"left":null,"right":null,"threshold":0},"right":{"feature":0,"impurity_index":0.316584564860427,"label_confidence":{"false":0.793103448275862,"true":0.206896551724138},"left":{"feature":0,"impurity_index":0.36734693877551,"label_confidence":{"false":0.714285714285714,"true":0.285714285714286},"left":null,"right":null,"threshold":-0.44095402956009},"right":{"feature":1,"impurity_index":0.19047619047619,"label_confidence":{"false":0.866666666666667,"true":0.133333333333333},"left":null,"right":null,"threshold":-0.17393381098906},"threshold":-0.29833596944809},"threshold":-0.58742213506952},"right":{"feature":0,"impurity_index":0,"label_confidence":{"false":1},"left":null,"right":null,"threshold":0},"threshold":0.00656049752607946},"threshold":0.000835362188632588},"right":{"feature":0,"impurity_index":0,"label_confidence":{"false":1},"left":null,"right":null,"threshold":0},"threshold":0.239015817223199},"threshold":0},"threshold":0.00231539457625404},"threshold":0},"threshold":-0.91689342260361},"right":{"feature":0,"impurity_index":0.0368080080049231,"label_confidence":{"false":0.980863591756624,"true":0.0191364082433759},"left":{"feature":5,"impurity_index":0.0716639420012531,"label_confidence":{"false":0.961727183513248,"true":0.0382728164867517},"left":{"feature":5,"impurity_index":0.00995725345460349,"label_confidence":{"false":0.994976977814985,"true":0.00502302218501465},"left":{"feature":15,"impurity_index":0.0219544950271512,"label_confidence":{"false":0.988847583643123,"true":0.0111524163568773},"left":{"feature":16,"impurity_index":0.0307499446943441,"label_confidence":{"false":0.984293193717278,"true":0.0157068062827225},"left":{"feature":0,"impurity_index":0,"label_confidence":{"false":1},"left":null,"right":null,"threshold":0},"right":{"feature":4,"impurity_index":0.0412038665559793,"label_confidence":{"false":0.97887323943662,"true":0.0211267605633803},"left":{"feature":0,"impurity_index":0.0577319587628866,"label_confidence":{"false":0.969230769230769,"true":0.0307692307692308},"left":{"feature":5,"impurity_index":0.0972017673048601,"label_confidence":{"false":0.938144329896907,"true":0.0618556701030928},"left":{"feature":0,"impurity_index":0,"label_confidence":{"false":1},"left":null,"right":null,"threshold":0},"right":{"feature":0,"impurity_index":0.31547619047619,"label_confidence":{"false":0.785714285714286,"true":0.214285714285714},"left":{"feature":4,"impurity_index":0.1875,"label_confidence":{"false":0.875,"true":0.125},"left":null,"right":null,"threshold":-0.00179839634802},"right":{"feature":0,"impurity_index":0.222222222222222,"label_confidence":{"false":0.666666666666667,"true":0.333333333333333},"left":null,"right":null,"threshold":0.429123818874359},"threshold":0.218630082521115},"threshold":-0.01043230205132},"right":{"feature":0,"impurity_index":0,"label_confidence":{"false":1},"left":null,"right":null,"threshold":0},"threshold":0.476027011871338},"right":{"feature":0,"impurity_index":0.0252904989747094,"label_confidence":{"false":0.987012987012987,"true":0.012987012987013},"left":{"feature":5,"impurity_index":0.0495951417004048,"label_confidence":{"false":0.973684210526316,"true":0.0263157894736842},"left":{"feature":12,"impurity_index":0.10207100591716,"label_confidence":{"false":0.942307692307692,"true":0.0576923076923077},"left":{"feature":2,"impurity_index":0.177514792899408,"label_confidence":{"false":0.884615384615385,"true":0.115384615384615},"left":null,"right":null,"threshold":-0.00958499172702},"right":{"feature":0,"impurity_index":0,"label_confidence":{"false":1},"left":null,"right":null,"threshold":0},"threshold":0.0147058823529412},"right":{"feature":0,"impurity_index":0,"label_confidence":{"false":1},"left":null,"right":null,"threshold":0},"threshold":-0.00630316257203},"right":{"feature":0,"impurity_index":0,"label_confidence":{"false":1},"left":null,"right":null,"threshold":0},"threshold":0.131712008267641},"threshold":-0.00081035120478},"threshold":0},"right":{"feature":0,"impurity_index":0,"label_confidence":{"false":1},"left":null,"right":null,"threshold":0},"threshold":0.27633209417596},"right":{"feature":8,"impurity_index":0.00375949549044829,"label_confidence":{"false":0.998103666245259,"true":0.00189633375474083},"left":{"feature":0,"impurity_index":0,"label_confidence":{"false":1},"left":null,"right":null,"threshold":0},"right":{"feature":3,"impurity_index":0.0171068427370949,"label_confidence":{"false":0.991253644314869,"true":0.0087463556851312},"left":{"feature":0,"impurity_index":0,"label_confidence":{"false":1},"left":null,"right":null,"threshold":0},"right":{"feature":16,"impurity_index":0.0417112299465241,"label_confidence":{"false":0.977941176470588,"true":0.0220588235294118},"left":{"feature":0,"impurity_index":0,"label_confidence":{"false":1},"left":null,"right":null,"threshold":0},"right":{"feature":12,"impurity_index":0.096,"label_confidence":{"false":0.945454545454545,"true":0.0545454545454545},"left":{"feature":11,"impurity_index":0.184615384615385,"label_confidence":{"false":0.88,"true":0.12},"left":{"feature":0,"impurity_index":0,"label_confidence":{"false":1},"left":null,"right":null,"threshold":0},"right":{"feature":14,"impurity_index":0.290598290598291,"label_confidence":{"false":0.769230769230769,"true":0.230769230769231},"left":{"feature":0,"impurity_index":0.5,"label_confidence":{"false":0.5,"true":0.5},"left":null,"right":null,"threshold":0.0000000166893006081636},"right":{"feature":1,"impurity_index":0.166666666666667,"label_confidence":{"false":0.888888888888889,"true":0.111111111111111},"left":null,"right":null,"threshold":0.897748195462757},"threshold":0.0258346581875994},"threshold":0.00787056516855955},"right":{"feature":0,"impurity_index":0,"label_confidence":{"false":1},"left":null,"right":null,"threshold":0},"threshold":0.0224454400924989},"threshold":-0.59558823529412},"threshold":0.00245697764341892},"threshold":0.000456081577170631},"threshold":-0.0024147267146},"right":{"feature":9,"impurity_index":0.120667446985687,"label_confidence":{"false":0.932372505543237,"true":0.0676274944567627},"left":{"feature":1,"impurity_index":0.190453858385018,"label_confidence":{"false":0.880177514792899,"true":0.119822485207101},"left":{"feature":4,"impurity_index":0.0294581661171874,"label_confidence":{"false":0.984709480122324,"true":0.0152905198776758},"left":{"feature":14,"impurity_index":0.0754242614707731,"label_confidence":{"false":0.959459459459459,"true":0.0405405405405405},"left":{"feature":0,"impurity_index":0,"label_confidence":{"false":1},"left":null,"right":null,"threshold":0},"right":{"feature":12,"impurity_index":0.12363850456285,"label_confidence":{"false":0.930232558139535,"true":0.0697674418604651},"left":{"feature":0,"impurity_index":0,"label_confidence":{"false":1},"left":null,"right":null,"threshold":0},"right":{"feature":12,"impurity_index":0.172425590147109,"label_confidence":{"false":0.886075949367089,"true":0.113924050632911},"left":{"feature":1,"impurity_index":0.353808353808354,"label_confidence":{"false":0.756756756756757,"true":0.243243243243243},"left":{"feature":4,"impurity_index":0.363636363636364,"label_confidence":{"false":0.727272727272727,"true":0.272727272727273},"left":null,"right":null,"threshold":-0.01000000996459},"right":{"feature":0,"impurity_index":0,"label_confidence":{"false":1},"left":null,"right":null,"threshold":0},"threshold":-1.21056066977011},"right":{"feature":0,"impurity_index":0,"label_confidence":{"false":1},"left":null,"right":null,"threshold":0},"threshold":0.0524642289348172},"threshold":0.0287062027828102},"threshold":0.00119236883942766},"right":{"feature":11,"impurity_index":0.00459583671262506,"label_confidence":{"false":0.997685185185185,"true":0.00231481481481481},"left":{"feature":8,"impurity_index":0.0142424781912053,"label_confidence":{"false":0.992700729927007,"true":0.0072992700729927},"left":{"feature":7,"impurity_index":0.0459110473457675,"label_confidence":{"false":0.975609756097561,"true":0.024390243902439},"left":{"feature":0,"impurity_index":0,"label_confidence":{"false":1},"left":null,"right":null,"threshold":0},"right":{"feature":0,"impurity_index":0.100840336134454,"label_confidence":{"false":0.941176470588235,"true":0.0588235294117647},"left":{"feature":14,"impurity_index":0.142857142857143,"label_confidence":{"false":0.857142857142857,"true":0.142857142857143},"left":null,"right":null,"threshold":-0.07148535089712},"right":{"feature":0,"impurity_index":0,"label_confidence":{"false":1},"left":null,"right":null,"threshold":0},"threshold":0.0588155161047519},"threshold":-0.0243006653902},"right":{"feature":0,"impurity_index":0,"label_confidence":{"false":1},"left":null,"right":null,"threshold":0},"threshold":-0.00054383581419},"right":{"feature":0,"impurity_index":0,"label_confidence":{"false":1},"left":null,"right":null,"threshold":0},"threshold":-0.00172915549664},"threshold":-0.00356414856076},"right":{"feature":0,"impurity_index":0.264759731036691,"label_confidence":{"false":0.782234957020057,"true":0.217765042979943},"left":{"feature":1,"impurity_index":0.141341938741101,"label_confidence":{"false":0.587392550143267,"true":0.412607449856734},"left":{"feature":0,"impurity_index":0,"label_confidence":{"false":0.159763313609467,"true":0.840236686390533},"left":null,"right":null,"threshold":0.0092335900611426},"right":{"feature":14,"impurity_index":0.021256038647343,"label_confidence":{"false":0.988888888888889,"true":0.0111111111111111},"left":{"feature":12,"impurity_index":0.0767263427109975,"label_confidence":{"false":0.956521739130435,"true":0.0434782608695652},"left":{"feature":2,"impurity_index":0.176470588235294,"label_confidence":{"false":0.882352941176471,"true":0.117647058823529},"left":{"feature":7,"impurity_index":0.166666666666667,"label_confidence":{"false":0.75,"true":0.25},"left":null,"right":null,"threshold":-0.0164731747459},"right":{"feature":0,"impurity_index":0,"label_confidence":{"false":1},"left":null,"right":null,"threshold":0},"threshold":0.0373854581266642},"right":{"feature":0,"impurity_index":0,"label_confidence":{"false":1},"left":null,"right":null,"threshold":0},"threshold":0.00387087855118545},"right":{"feature":0,"impurity_index":0,"label_confidence":{"false":1},"left":null,"right":null,"threshold":0},"threshold":0},"threshold":0.000000119209289550781},"right":{"feature":13,"impurity_index":0.0431285153348191,"label_confidence":{"false":0.977077363896848,"true":0.0229226361031519},"left":{"feature":0,"impurity_index":0.104575163398693,"label_confidence":{"false":0.940740740740741,"true":0.0592592592592593},"left":{"feature":0,"impurity_index":0,"label_confidence":{"false":1},"left":null,"right":null,"threshold":0},"right":{"feature":0,"impurity_index":0.191518467852257,"label_confidence":{"false":0.882352941176471,"true":0.117647058823529},"left":{"feature":0,"impurity_index":0.266284103493406,"label_confidence":{"false":0.813953488372093,"true":0.186046511627907},"left":{"feature":14,"impurity_index":0.0761904761904761,"label_confidence":{"false":0.952380952380952,"true":0.0476190476190476},"left":null,"right":null,"threshold":-0.00119236883943},"right":{"feature":2,"impurity_index":0.354545454545455,"label_confidence":{"false":0.681818181818182,"true":0.318181818181818},"left":null,"right":null,"threshold":-0.06862204699692},"threshold":0.527737975120544},"right":{"feature":0,"impurity_index":0,"label_confidence":{"false":1},"left":null,"right":null,"threshold":0},"threshold":0.554235251620412},"threshold":0.491225838661194},"right":{"feature":0,"impurity_index":0,"label_confidence":{"false":1},"left":null,"right":null,"threshold":0},"threshold":0},"threshold":0.0938588976860046},"threshold":0},"right":{"feature":16,"impurity_index":0.0303952528905414,"label_confidence":{"false":0.984490398818316,"true":0.0155096011816839},"left":{"feature":0,"impurity_index":0,"label_confidence":{"false":1},"left":null,"right":null,"threshold":0},"right":{"feature":4,"impurity_index":0.039272030651341,"label_confidence":{"false":0.979885057471264,"true":0.0201149425287356},"left":{"feature":0,"impurity_index":0.0223939754260801,"label_confidence":{"false":0.988505747126437,"true":0.0114942528735632},"left":{"feature":4,"impurity_index":0.0490254872563718,"label_confidence":{"false":0.974137931034483,"true":0.0258620689655172},"left":{"feature":4,"impurity_index":0.0923076923076923,"label_confidence":{"false":0.947826086956522,"true":0.0521739130434783},"left":{"feature":0,"impurity_index":0,"label_confidence":{"false":1},"left":null,"right":null,"threshold":0},"right":{"feature":4,"impurity_index":0.173076923076923,"label_confidence":{"false":0.884615384615385,"true":0.115384615384615},"left":{"feature":5,"impurity_index":0.25,"label_confidence":{"false":0.75,"true":0.25},"left":null,"right":null,"threshold":0.00421970697061624},"right":{"feature":0,"impurity_index":0,"label_confidence":{"false":1},"left":null,"right":null,"threshold":0},"threshold":-0.00991837028414},"threshold":-0.01537317544909},"right":{"feature":0,"impurity_index":0,"label_confidence":{"false":1},"left":null,"right":null,"threshold":0},"threshold":-0.00984665079159},"right":{"feature":0,"impurity_index":0,"label_confidence":{"false":1},"left":null,"right":null,"threshold":0},"threshold":0.471478322041577},"right":{"feature":4,"impurity_index":0.0553986496611665,"label_confidence":{"false":0.971264367816092,"true":0.028735632183908},"left":{"feature":0,"impurity_index":0.031812673130194,"label_confidence":{"false":0.983552631578947,"true":0.0164473684210526},"left":{"feature":4,"impurity_index":0.0625958099131323,"label_confidence":{"false":0.967105263157895,"true":0.0328947368421053},"left":{"feature":0,"impurity_index":0.0902618417181525,"label_confidence":{"false":0.951456310679612,"true":0.0485436893203883},"left":{"feature":5,"impurity_index":0.0346320346320346,"label_confidence":{"false":0.981818181818182,"true":0.0181818181818182},"left":null,"right":null,"threshold":0.00525428776658806},"right":{"feature":0,"impurity_index":0.138888888888889,"label_confidence":{"false":0.916666666666667,"true":0.0833333333333333},"left":null,"right":null,"threshold":0.0856618955731392},"threshold":0.0517406561359623},"right":{"feature":0,"impurity_index":0,"label_confidence":{"false":1},"left":null,"right":null,"threshold":0},"threshold":0.00202666010260582},"right":{"feature":0,"impurity_index":0,"label_confidence":{"false":1},"left":null,"right":null,"threshold":0},"threshold":0.170076872734537},"right":{"feature":0,"impurity_index":0.0847928829580206,"label_confidence":{"false":0.954128440366973,"true":0.0458715596330275},"left":{"feature":0,"impurity_index":0,"label_confidence":{"false":1},"left":null,"right":null,"threshold":0},"right":{"feature":0,"impurity_index":0.128558310376492,"label_confidence":{"false":0.924242424242424,"true":0.0757575757575758},"left":{"feature":0,"impurity_index":0.211202938475666,"label_confidence":{"false":0.848484848484849,"true":0.151515151515152},"left":{"feature":0,"impurity_index":0.397281639928699,"label_confidence":{"false":0.696969696969697,"true":0.303030303030303},"left":null,"right":null,"threshold":0.55548232793808},"right":{"feature":0,"impurity_index":0,"label_confidence":{"false":1},"left":null,"right":null,"threshold":0},"threshold":0.570406138896942},"right":{"feature":0,"impurity_index":0,"label_confidence":{"false":1},"left":null,"right":null,"threshold":0},"threshold":0.620304048061371},"threshold":0.424795880127664},"threshold":0.0096506327250149},"threshold":-0.00036244944204},"threshold":0},"threshold":0.000120637654617894},"threshold":0},"right":{"feature":0,"impurity_index":0,"label_confidence":{"false":1},"left":null,"right":null,"threshold":0},"threshold":0.905144637450576},"threshold":0}')

func remap(source_skeleton:Skeleton3D, sink_skeleton:Skeleton3D) -> Dictionary:
	# Returns a mapping from bone_id in source skeleton to bone_id in target_skeleton.
	var mapping = Dictionary()
	var source_skeleton_features = self.make_features_for_skeleton(source_skeleton)
	var target_skeleton_features = self.make_features_for_skeleton(sink_skeleton)
	
	# Probability table.
	var probability_match:Dictionary = Dictionary()  # Map from the target/sink bone id to the most likely sources.
	for target_bone_id in range(0, sink_skeleton.get_bone_count()):
		var target_feature = target_skeleton_features[target_bone_id]
		probability_match[target_bone_id] = Dictionary()
		for source_bone_id in range(0, source_skeleton.get_bone_count()):
			var source_feature = source_skeleton_features[source_bone_id]
			var feature = []
			for feature_index in range(0, len(source_feature)):
				feature.append(source_feature[feature_index] - target_feature[feature_index])
			# DT is trained to map to labels 'true' and 'false'.
			probability_match[target_bone_id][source_bone_id] = dt.predict_with_probability(feature)[true]
	
	# Assign from root outwards.  Use the maximum probability match.
	# This does not maximize the overall probability, but puts greater priority on root bones.
	var used_bones = Dictionary()
	# Start by finding all the potential unparented bones in the sink skeleton because those will be roots.
	var next_bones_to_assign = Array(sink_skeleton.get_parentless_bones())
	while len(next_bones_to_assign) > 0:
		var current_bone = next_bones_to_assign.pop_front()
		var child_bones = sink_skeleton.get_bone_children(current_bone)
		next_bones_to_assign.append_array(Array(child_bones))
		# Need to actually map the bones now.
		var best_match_id = -1
		var best_match_value = -1
		for potential_match_bone_id in range(0, source_skeleton.get_bone_count()):
			if probability_match[current_bone][potential_match_bone_id] > best_match_value:
				best_match_value = probability_match[current_bone][potential_match_bone_id]
				best_match_id = potential_match_bone_id
		mapping[best_match_id] = current_bone
	
	return mapping

func train():
	var bone_descriptors = Dictionary()  # name -> list of list of features
	# Ring finger -> [all the different bones we've seen that also ring fingers]
	
	for child in self.get_children():
		if not child.visible:
			continue
		var skeleton = child.get_node("skeleton")
		if skeleton == null:
			print(child.name)
			print("MISSING SKELETON!  X HAS NO BONES!")
			continue
		var skeleton_properties = make_features_for_skeleton(skeleton)
		for name in skeleton_properties.keys():
			if not bone_descriptors.has(name):
				bone_descriptors[name] = []
			bone_descriptors[name].append(skeleton_properties[name])

	# DEBUG: Save a CSV of this data:
	#var f = File.new()
	#f.open("user://file.csv", File.WRITE_READ)

	# Build all possible pairs of bones.
	# [[bone_properties_a, bone_properties_b, 1/0], ...]
	var examples:Array = []
	var labels:Array = []
	var first : bool = true
	for bone_name_a in bone_descriptors.keys():
		for bone_array_a in bone_descriptors[bone_name_a]:
			for bone_name_b in bone_descriptors.keys():
				for bone_array_b in bone_descriptors[bone_name_b]:
					var feature_vector = []
					for i in range(0, len(bone_array_a)):
						feature_vector.append(bone_array_a[i] - bone_array_b[i])
					examples.append(feature_vector)
					labels.append(bone_name_a == bone_name_b)
					
					# DEBUG:
					"""
					var header : PackedStringArray
					if first:
						header.push_back("label")
						header.push_back("vector")
						f.store_csv_line(header, "\t")
						first = false
					var line : PackedStringArray
					line.push_back(str(bone_name_a == bone_name_b))
					var feature_string : String = ""
					for feature in feature_vector:
						feature_string = feature_string + str(feature) + " "
					line.push_back(feature_string)
					f.store_csv_line(line, "\t")
					"""
	
	# Train our model.
	var dt = DecisionTree.new()
	dt.train(examples, labels, 10)
	print(dt.save_to_json())
	return dt

func compute_bone_depth_and_child_count(skeleton:Skeleton3D, bone_id:int, skeleton_info:Dictionary):
	# Mutates the given skeleton_info_dictionary
	# Sets a mapping from bone_id to {"children": count, "depth": int, "siblings": int}
	
	# Assume that our skeleton always has at least one bone.
	assert(skeleton.get_bone_count() > 0)
	
	# Initialize our dictionary entry.
	if not skeleton_info.has(bone_id):
		skeleton_info[bone_id] = {
			"children": 0,  # Fill in here.
			"depth": 0,  # Don't worry about depth for this node.  It will be assigned by the parent.
			"siblings": 0,  # Let parent fill this in.
		}
	
	# TODO: Handle multiple roots of the skeleton?
	var parent_id: int = skeleton.get_bone_parent(bone_id)
	if parent_id == -1:
		skeleton_info[bone_id]["depth"] = 0
	# NOTE: Godot has no way to get the children of a bone via function call, so we iterate over and check the nodes which have this as a parent.
	var child_bone_ids: Array[int] = []
	for child_bone_id in range(0, skeleton.get_bone_count()):
		if skeleton.get_bone_parent(child_bone_id) == bone_id:
			child_bone_ids.append(child_bone_id)
	
	skeleton_info[bone_id]["children"] = len(child_bone_ids)
	for child_id in child_bone_ids:
		if not skeleton_info.has(child_id):  # Don't override if set.
			skeleton_info[child_id] = {
				"children": 0,
				"depth": skeleton_info[bone_id]["depth"] + 1,
				"siblings": len(child_bone_ids)
			}
		compute_bone_depth_and_child_count(skeleton, child_id, skeleton_info)
	
	return skeleton_info

func make_features_for_skeleton(skeleton:Skeleton3D) -> Dictionary:
	# Return a mapping from BONE NAME to a feature array.
	var result = {}
	
	var bone_count = skeleton.get_bone_count()
	
	# For each bone, if it's a root node, compute the properties it needs.
	var bone_depth_info = Dictionary()
	for bone_id in range(0, skeleton.get_bone_count()):
		if skeleton.get_bone_parent(bone_id) == -1:  # If this is a root bone...
			compute_bone_depth_and_child_count(skeleton, bone_id, bone_depth_info)

	# Start by finding the depth of every bone.
	for bone_id in skeleton.get_bone_count():
		var pose:Transform3D = skeleton.global_pose_to_world_transform(skeleton.get_bone_global_pose(bone_id))  # get_global_rest_pose?
		# Do some extra name properties:
		var string_prop_name_left:float = 0.0
		var string_prop_name_right:float = 0.0
		if skeleton.get_bone_name(bone_id).to_lower().contains("left"):
			string_prop_name_left = 1.0
		if skeleton.get_bone_name(bone_id).to_lower().contains("right"):
			string_prop_name_right = 1.0
		# Build vec:
		result[skeleton.get_bone_name(bone_id)] = [
			# Position
			pose.origin.x, pose.origin.y, pose.origin.z, 
			# Rotation
			pose.basis.x.x, pose.basis.x.y, pose.basis.x.z,
			pose.basis.y.x, pose.basis.y.y, pose.basis.y.z,
			pose.basis.z.x, pose.basis.z.y, pose.basis.z.z,
			# Scale?
			# Hierarchy info -- TODO: Normalize
			float(bone_depth_info[bone_id]["depth"]) / float(bone_count),
			float(bone_depth_info[bone_id]["children"]) / float(bone_count),
			float(bone_depth_info[bone_id]["siblings"]) / float(bone_count), 
			# Wish I could do stuff with names.  :'(
			string_prop_name_left,
			string_prop_name_right,
		]
	return result
