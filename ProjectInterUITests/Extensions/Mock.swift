//
//  Mock.swift
//  ProjectInter
//
//  Created by Brendan Chen on 2025.07.08.
//

import Foundation
import ApolloTestSupport
import ProjectInterTestMocks

let mapRouteMockJSONArray = """
[
  {
    "latitude": 33.793316000,
    "longitude": -117.852810000
  },
  {
    "latitude": 33.793315000,
    "longitude": -117.852996000
  },
  {
    "latitude": 33.793311000,
    "longitude": -117.853097000
  },
  {
    "latitude": 33.793311000,
    "longitude": -117.853212000
  },
  {
    "latitude": 33.793311000,
    "longitude": -117.853367000
  },
  {
    "latitude": 33.793311000,
    "longitude": -117.853698000
  },
  {
    "latitude": 33.793310000,
    "longitude": -117.854187000
  },
  {
    "latitude": 33.793322000,
    "longitude": -117.855284000
  },
  {
    "latitude": 33.793323000,
    "longitude": -117.856355000
  },
  {
    "latitude": 33.793230000,
    "longitude": -117.856356000
  },
  {
    "latitude": 33.791598000,
    "longitude": -117.856366000
  },
  {
    "latitude": 33.791517000,
    "longitude": -117.856367000
  },
  {
    "latitude": 33.791437000,
    "longitude": -117.856363000
  },
  {
    "latitude": 33.791312000,
    "longitude": -117.856358000
  },
  {
    "latitude": 33.790351000,
    "longitude": -117.856360000
  },
  {
    "latitude": 33.789782000,
    "longitude": -117.856364000
  },
  {
    "latitude": 33.789701000,
    "longitude": -117.856365000
  },
  {
    "latitude": 33.789620000,
    "longitude": -117.856370000
  },
  {
    "latitude": 33.789279000,
    "longitude": -117.856365000
  },
  {
    "latitude": 33.788321000,
    "longitude": -117.856366000
  },
  {
    "latitude": 33.787970000,
    "longitude": -117.856375000
  },
  {
    "latitude": 33.787889000,
    "longitude": -117.856375000
  },
  {
    "latitude": 33.787889000,
    "longitude": -117.856470000
  },
  {
    "latitude": 33.787890000,
    "longitude": -117.856602000
  },
  {
    "latitude": 33.787891000,
    "longitude": -117.856783000
  },
  {
    "latitude": 33.787891000,
    "longitude": -117.856888000
  },
  {
    "latitude": 33.787891000,
    "longitude": -117.856976000
  },
  {
    "latitude": 33.787893000,
    "longitude": -117.856979000
  },
  {
    "latitude": 33.787933000,
    "longitude": -117.857043000
  },
  {
    "latitude": 33.787933000,
    "longitude": -117.857458000
  },
  {
    "latitude": 33.787933000,
    "longitude": -117.857518000
  },
  {
    "latitude": 33.787933000,
    "longitude": -117.857827000
  },
  {
    "latitude": 33.787933000,
    "longitude": -117.857907000
  },
  {
    "latitude": 33.787886000,
    "longitude": -117.857986000
  },
  {
    "latitude": 33.787887000,
    "longitude": -117.858081000
  },
  {
    "latitude": 33.787887000,
    "longitude": -117.858293000
  },
  {
    "latitude": 33.787887000,
    "longitude": -117.858476000
  },
  {
    "latitude": 33.787887000,
    "longitude": -117.858556000
  },
  {
    "latitude": 33.787888000,
    "longitude": -117.858716000
  },
  {
    "latitude": 33.787888000,
    "longitude": -117.858868000
  },
  {
    "latitude": 33.787888000,
    "longitude": -117.859286000
  },
  {
    "latitude": 33.787888000,
    "longitude": -117.859323000
  },
  {
    "latitude": 33.787889000,
    "longitude": -117.859655000
  },
  {
    "latitude": 33.787888000,
    "longitude": -117.859990000
  },
  {
    "latitude": 33.787888000,
    "longitude": -117.860093000
  },
  {
    "latitude": 33.787887000,
    "longitude": -117.860392000
  },
  {
    "latitude": 33.787887000,
    "longitude": -117.860435000
  },
  {
    "latitude": 33.787887000,
    "longitude": -117.860739000
  },
  {
    "latitude": 33.787886000,
    "longitude": -117.861197000
  },
  {
    "latitude": 33.787885000,
    "longitude": -117.861519000
  },
  {
    "latitude": 33.787885000,
    "longitude": -117.861692000
  },
  {
    "latitude": 33.787884000,
    "longitude": -117.861825000
  },
  {
    "latitude": 33.787885000,
    "longitude": -117.861974000
  },
  {
    "latitude": 33.787884000,
    "longitude": -117.862261000
  },
  {
    "latitude": 33.787884000,
    "longitude": -117.862405000
  },
  {
    "latitude": 33.787884000,
    "longitude": -117.862684000
  },
  {
    "latitude": 33.787884000,
    "longitude": -117.862841000
  },
  {
    "latitude": 33.787884000,
    "longitude": -117.862915000
  },
  {
    "latitude": 33.787883000,
    "longitude": -117.863160000
  },
  {
    "latitude": 33.787883000,
    "longitude": -117.863697000
  },
  {
    "latitude": 33.787883000,
    "longitude": -117.863948000
  },
  {
    "latitude": 33.787883000,
    "longitude": -117.864010000
  },
  {
    "latitude": 33.787882000,
    "longitude": -117.864622000
  },
  {
    "latitude": 33.787882000,
    "longitude": -117.864681000
  },
  {
    "latitude": 33.787882000,
    "longitude": -117.864810000
  },
  {
    "latitude": 33.787882000,
    "longitude": -117.865075000
  },
  {
    "latitude": 33.787881000,
    "longitude": -117.865167000
  },
  {
    "latitude": 33.787881000,
    "longitude": -117.865442000
  },
  {
    "latitude": 33.787881000,
    "longitude": -117.865554000
  },
  {
    "latitude": 33.787938000,
    "longitude": -117.865679000
  },
  {
    "latitude": 33.787938000,
    "longitude": -117.866004000
  },
  {
    "latitude": 33.787939000,
    "longitude": -117.866335000
  },
  {
    "latitude": 33.787940000,
    "longitude": -117.866502000
  },
  {
    "latitude": 33.787940000,
    "longitude": -117.866645000
  },
  {
    "latitude": 33.787941000,
    "longitude": -117.866964000
  },
  {
    "latitude": 33.787942000,
    "longitude": -117.867104000
  },
  {
    "latitude": 33.787888000,
    "longitude": -117.867306000
  },
  {
    "latitude": 33.787880000,
    "longitude": -117.867944000
  },
  {
    "latitude": 33.787880000,
    "longitude": -117.868030000
  },
  {
    "latitude": 33.787881000,
    "longitude": -117.868222000
  },
  {
    "latitude": 33.787881000,
    "longitude": -117.868308000
  },
  {
    "latitude": 33.787881000,
    "longitude": -117.868433000
  },
  {
    "latitude": 33.787883000,
    "longitude": -117.868666000
  },
  {
    "latitude": 33.787885000,
    "longitude": -117.868824000
  },
  {
    "latitude": 33.787884000,
    "longitude": -117.869024000
  },
  {
    "latitude": 33.787886000,
    "longitude": -117.869190000
  },
  {
    "latitude": 33.787882000,
    "longitude": -117.869589000
  },
  {
    "latitude": 33.787882000,
    "longitude": -117.869975000
  },
  {
    "latitude": 33.787881000,
    "longitude": -117.870171000
  },
  {
    "latitude": 33.787883000,
    "longitude": -117.870517000
  },
  {
    "latitude": 33.787883000,
    "longitude": -117.870767000
  },
  {
    "latitude": 33.787883000,
    "longitude": -117.870965000
  },
  {
    "latitude": 33.787883000,
    "longitude": -117.871162000
  },
  {
    "latitude": 33.787883000,
    "longitude": -117.871513000
  },
  {
    "latitude": 33.787884000,
    "longitude": -117.871607000
  },
  {
    "latitude": 33.787883000,
    "longitude": -117.871711000
  },
  {
    "latitude": 33.787883000,
    "longitude": -117.871983000
  },
  {
    "latitude": 33.787883000,
    "longitude": -117.872161000
  },
  {
    "latitude": 33.787883000,
    "longitude": -117.872335000
  },
  {
    "latitude": 33.787883000,
    "longitude": -117.872562000
  },
  {
    "latitude": 33.787883000,
    "longitude": -117.872633000
  },
  {
    "latitude": 33.787883000,
    "longitude": -117.872802000
  },
  {
    "latitude": 33.787883000,
    "longitude": -117.873037000
  },
  {
    "latitude": 33.787883000,
    "longitude": -117.873109000
  },
  {
    "latitude": 33.787883000,
    "longitude": -117.873275000
  },
  {
    "latitude": 33.787883000,
    "longitude": -117.873361000
  },
  {
    "latitude": 33.787884000,
    "longitude": -117.873785000
  },
  {
    "latitude": 33.787884000,
    "longitude": -117.873824000
  },
  {
    "latitude": 33.787886000,
    "longitude": -117.874423000
  },
  {
    "latitude": 33.787887000,
    "longitude": -117.874561000
  },
  {
    "latitude": 33.787886000,
    "longitude": -117.874578000
  },
  {
    "latitude": 33.787887000,
    "longitude": -117.875020000
  },
  {
    "latitude": 33.787887000,
    "longitude": -117.875270000
  },
  {
    "latitude": 33.787887000,
    "longitude": -117.875389000
  },
  {
    "latitude": 33.787887000,
    "longitude": -117.875705000
  },
  {
    "latitude": 33.787889000,
    "longitude": -117.876046000
  },
  {
    "latitude": 33.787888000,
    "longitude": -117.876358000
  },
  {
    "latitude": 33.787888000,
    "longitude": -117.876702000
  },
  {
    "latitude": 33.787888000,
    "longitude": -117.876796000
  },
  {
    "latitude": 33.787889000,
    "longitude": -117.877097000
  },
  {
    "latitude": 33.787888000,
    "longitude": -117.877582000
  },
  {
    "latitude": 33.787888000,
    "longitude": -117.877601000
  },
  {
    "latitude": 33.787889000,
    "longitude": -117.877685000
  },
  {
    "latitude": 33.787889000,
    "longitude": -117.877739000
  },
  {
    "latitude": 33.787889000,
    "longitude": -117.877933000
  },
  {
    "latitude": 33.787890000,
    "longitude": -117.878024000
  },
  {
    "latitude": 33.787890000,
    "longitude": -117.878150000
  },
  {
    "latitude": 33.787890000,
    "longitude": -117.878380000
  },
  {
    "latitude": 33.787890000,
    "longitude": -117.878542000
  },
  {
    "latitude": 33.787891000,
    "longitude": -117.878604000
  },
  {
    "latitude": 33.787891000,
    "longitude": -117.878628000
  },
  {
    "latitude": 33.787940000,
    "longitude": -117.878721000
  },
  {
    "latitude": 33.787946000,
    "longitude": -117.878943000
  },
  {
    "latitude": 33.787950000,
    "longitude": -117.879220000
  },
  {
    "latitude": 33.787947000,
    "longitude": -117.879543000
  },
  {
    "latitude": 33.787932000,
    "longitude": -117.880310000
  },
  {
    "latitude": 33.787929000,
    "longitude": -117.880465000
  },
  {
    "latitude": 33.787930000,
    "longitude": -117.880566000
  },
  {
    "latitude": 33.787930000,
    "longitude": -117.880625000
  },
  {
    "latitude": 33.787932000,
    "longitude": -117.881015000
  },
  {
    "latitude": 33.787869000,
    "longitude": -117.881189000
  },
  {
    "latitude": 33.787874000,
    "longitude": -117.881424000
  },
  {
    "latitude": 33.787877000,
    "longitude": -117.881621000
  },
  {
    "latitude": 33.787878000,
    "longitude": -117.881727000
  },
  {
    "latitude": 33.787883000,
    "longitude": -117.882974000
  },
  {
    "latitude": 33.787901000,
    "longitude": -117.883304000
  },
  {
    "latitude": 33.787909000,
    "longitude": -117.883363000
  },
  {
    "latitude": 33.787956000,
    "longitude": -117.883695000
  },
  {
    "latitude": 33.787992000,
    "longitude": -117.883830000
  },
  {
    "latitude": 33.788014000,
    "longitude": -117.883957000
  },
  {
    "latitude": 33.788100000,
    "longitude": -117.884219000
  },
  {
    "latitude": 33.788216000,
    "longitude": -117.884521000
  },
  {
    "latitude": 33.788229000,
    "longitude": -117.884547000
  },
  {
    "latitude": 33.788366000,
    "longitude": -117.884815000
  },
  {
    "latitude": 33.788446000,
    "longitude": -117.884941000
  },
  {
    "latitude": 33.788819000,
    "longitude": -117.885531000
  },
  {
    "latitude": 33.788893000,
    "longitude": -117.885639000
  },
  {
    "latitude": 33.789115000,
    "longitude": -117.886014000
  },
  {
    "latitude": 33.789139000,
    "longitude": -117.886074000
  },
  {
    "latitude": 33.789293000,
    "longitude": -117.886458000
  },
  {
    "latitude": 33.789491000,
    "longitude": -117.886321000
  },
  {
    "latitude": 33.789583000,
    "longitude": -117.886182000
  },
  {
    "latitude": 33.789622000,
    "longitude": -117.886127000
  },
  {
    "latitude": 33.789638000,
    "longitude": -117.886143000
  },
  {
    "latitude": 33.789733000,
    "longitude": -117.886236000
  },
  {
    "latitude": 33.789622000,
    "longitude": -117.886127000
  },
  {
    "latitude": 33.789573000,
    "longitude": -117.886197000
  },
  {
    "latitude": 33.789491000,
    "longitude": -117.886321000
  },
  {
    "latitude": 33.789293000,
    "longitude": -117.886458000
  },
  {
    "latitude": 33.789306000,
    "longitude": -117.886505000
  },
  {
    "latitude": 33.789392000,
    "longitude": -117.886814000
  },
  {
    "latitude": 33.789494000,
    "longitude": -117.887171000
  },
  {
    "latitude": 33.789507000,
    "longitude": -117.887303000
  },
  {
    "latitude": 33.789519000,
    "longitude": -117.887449000
  },
  {
    "latitude": 33.789504000,
    "longitude": -117.887942000
  },
  {
    "latitude": 33.789481000,
    "longitude": -117.888098000
  },
  {
    "latitude": 33.789454000,
    "longitude": -117.888414000
  },
  {
    "latitude": 33.789467000,
    "longitude": -117.888536000
  },
  {
    "latitude": 33.789477000,
    "longitude": -117.888629000
  },
  {
    "latitude": 33.789431000,
    "longitude": -117.888858000
  },
  {
    "latitude": 33.789193000,
    "longitude": -117.889833000
  },
  {
    "latitude": 33.789079000,
    "longitude": -117.890474000
  },
  {
    "latitude": 33.789070000,
    "longitude": -117.890540000
  },
  {
    "latitude": 33.789050000,
    "longitude": -117.890692000
  },
  {
    "latitude": 33.789213000,
    "longitude": -117.890685000
  },
  {
    "latitude": 33.789240000,
    "longitude": -117.890682000
  },
  {
    "latitude": 33.789443000,
    "longitude": -117.890661000
  },
  {
    "latitude": 33.789572000,
    "longitude": -117.890639000
  },
  {
    "latitude": 33.789673000,
    "longitude": -117.890617000
  },
  {
    "latitude": 33.789791000,
    "longitude": -117.890583000
  },
  {
    "latitude": 33.789972000,
    "longitude": -117.890523000
  },
  {
    "latitude": 33.789994000,
    "longitude": -117.890515000
  },
  {
    "latitude": 33.790393000,
    "longitude": -117.890382000
  },
  {
    "latitude": 33.790715000,
    "longitude": -117.890275000
  },
  {
    "latitude": 33.790840000,
    "longitude": -117.890233000
  },
  {
    "latitude": 33.791287000,
    "longitude": -117.890090000
  },
  {
    "latitude": 33.791676000,
    "longitude": -117.889959000
  },
  {
    "latitude": 33.791969000,
    "longitude": -117.889853000
  },
  {
    "latitude": 33.792429000,
    "longitude": -117.889707000
  },
  {
    "latitude": 33.792554000,
    "longitude": -117.889667000
  },
  {
    "latitude": 33.792652000,
    "longitude": -117.889635000
  },
  {
    "latitude": 33.793067000,
    "longitude": -117.889526000
  },
  {
    "latitude": 33.793455000,
    "longitude": -117.889409000
  },
  {
    "latitude": 33.793623000,
    "longitude": -117.889359000
  },
  {
    "latitude": 33.794047000,
    "longitude": -117.889238000
  },
  {
    "latitude": 33.794232000,
    "longitude": -117.889198000
  },
  {
    "latitude": 33.794418000,
    "longitude": -117.889168000
  },
  {
    "latitude": 33.794570000,
    "longitude": -117.889154000
  },
  {
    "latitude": 33.794724000,
    "longitude": -117.889139000
  },
  {
    "latitude": 33.794892000,
    "longitude": -117.889128000
  },
  {
    "latitude": 33.795108000,
    "longitude": -117.889122000
  },
  {
    "latitude": 33.795424000,
    "longitude": -117.889117000
  },
  {
    "latitude": 33.795532000,
    "longitude": -117.889111000
  },
  {
    "latitude": 33.795727000,
    "longitude": -117.889100000
  },
  {
    "latitude": 33.795934000,
    "longitude": -117.889091000
  },
  {
    "latitude": 33.796137000,
    "longitude": -117.889082000
  },
  {
    "latitude": 33.796513000,
    "longitude": -117.889083000
  },
  {
    "latitude": 33.796740000,
    "longitude": -117.889083000
  },
  {
    "latitude": 33.797121000,
    "longitude": -117.889083000
  },
  {
    "latitude": 33.797353000,
    "longitude": -117.889084000
  },
  {
    "latitude": 33.797687000,
    "longitude": -117.889084000
  },
  {
    "latitude": 33.797876000,
    "longitude": -117.889085000
  },
  {
    "latitude": 33.798169000,
    "longitude": -117.889089000
  },
  {
    "latitude": 33.798868000,
    "longitude": -117.889102000
  },
  {
    "latitude": 33.799531000,
    "longitude": -117.889114000
  },
  {
    "latitude": 33.799563000,
    "longitude": -117.889117000
  },
  {
    "latitude": 33.799711000,
    "longitude": -117.889176000
  },
  {
    "latitude": 33.799711000,
    "longitude": -117.889396000
  },
  {
    "latitude": 33.799712000,
    "longitude": -117.889838000
  },
  {
    "latitude": 33.799712000,
    "longitude": -117.890642000
  },
  {
    "latitude": 33.799556000,
    "longitude": -117.890647000
  },
  {
    "latitude": 33.799500000,
    "longitude": -117.890647000
  },
  {
    "latitude": 33.797874000,
    "longitude": -117.890640000
  },
  {
    "latitude": 33.797874000,
    "longitude": -117.890360000
  },
  {
    "latitude": 33.797874000,
    "longitude": -117.889265000
  },
  {
    "latitude": 33.797506000,
    "longitude": -117.889272000
  },
  {
    "latitude": 33.797103000,
    "longitude": -117.889280000
  },
  {
    "latitude": 33.796975000,
    "longitude": -117.889282000
  },
  {
    "latitude": 33.796354000,
    "longitude": -117.889295000
  },
  {
    "latitude": 33.796134000,
    "longitude": -117.889299000
  },
  {
    "latitude": 33.795536000,
    "longitude": -117.889327000
  },
  {
    "latitude": 33.794906000,
    "longitude": -117.889329000
  },
  {
    "latitude": 33.794596000,
    "longitude": -117.889345000
  },
  {
    "latitude": 33.794387000,
    "longitude": -117.889372000
  },
  {
    "latitude": 33.794267000,
    "longitude": -117.889394000
  },
  {
    "latitude": 33.793940000,
    "longitude": -117.889494000
  },
  {
    "latitude": 33.793821000,
    "longitude": -117.889529000
  },
  {
    "latitude": 33.793667000,
    "longitude": -117.889574000
  },
  {
    "latitude": 33.793509000,
    "longitude": -117.889624000
  },
  {
    "latitude": 33.793349000,
    "longitude": -117.889674000
  },
  {
    "latitude": 33.792856000,
    "longitude": -117.889863000
  },
  {
    "latitude": 33.792685000,
    "longitude": -117.889920000
  },
  {
    "latitude": 33.792476000,
    "longitude": -117.889990000
  },
  {
    "latitude": 33.791770000,
    "longitude": -117.890225000
  },
  {
    "latitude": 33.791177000,
    "longitude": -117.890419000
  },
  {
    "latitude": 33.791019000,
    "longitude": -117.890471000
  },
  {
    "latitude": 33.790887000,
    "longitude": -117.890516000
  },
  {
    "latitude": 33.790764000,
    "longitude": -117.890559000
  },
  {
    "latitude": 33.790126000,
    "longitude": -117.890770000
  },
  {
    "latitude": 33.789925000,
    "longitude": -117.890837000
  },
  {
    "latitude": 33.789802000,
    "longitude": -117.890868000
  },
  {
    "latitude": 33.789759000,
    "longitude": -117.890877000
  },
  {
    "latitude": 33.789675000,
    "longitude": -117.890893000
  },
  {
    "latitude": 33.789591000,
    "longitude": -117.890907000
  },
  {
    "latitude": 33.789475000,
    "longitude": -117.890916000
  },
  {
    "latitude": 33.789328000,
    "longitude": -117.890924000
  },
  {
    "latitude": 33.789202000,
    "longitude": -117.890932000
  },
  {
    "latitude": 33.789041000,
    "longitude": -117.890936000
  },
  {
    "latitude": 33.788903000,
    "longitude": -117.890936000
  },
  {
    "latitude": 33.788904000,
    "longitude": -117.890700000
  },
  {
    "latitude": 33.788909000,
    "longitude": -117.890516000
  },
  {
    "latitude": 33.788913000,
    "longitude": -117.890489000
  },
  {
    "latitude": 33.788954000,
    "longitude": -117.890197000
  },
  {
    "latitude": 33.789050000,
    "longitude": -117.889708000
  },
  {
    "latitude": 33.789086000,
    "longitude": -117.889537000
  },
  {
    "latitude": 33.789321000,
    "longitude": -117.888520000
  },
  {
    "latitude": 33.789397000,
    "longitude": -117.888460000
  },
  {
    "latitude": 33.789454000,
    "longitude": -117.888414000
  },
  {
    "latitude": 33.789481000,
    "longitude": -117.888098000
  },
  {
    "latitude": 33.789504000,
    "longitude": -117.887942000
  },
  {
    "latitude": 33.789519000,
    "longitude": -117.887449000
  },
  {
    "latitude": 33.789507000,
    "longitude": -117.887303000
  },
  {
    "latitude": 33.789494000,
    "longitude": -117.887171000
  },
  {
    "latitude": 33.789392000,
    "longitude": -117.886814000
  },
  {
    "latitude": 33.789293000,
    "longitude": -117.886458000
  },
  {
    "latitude": 33.789336000,
    "longitude": -117.886428000
  },
  {
    "latitude": 33.789491000,
    "longitude": -117.886321000
  },
  {
    "latitude": 33.789583000,
    "longitude": -117.886182000
  },
  {
    "latitude": 33.789622000,
    "longitude": -117.886127000
  },
  {
    "latitude": 33.789732000,
    "longitude": -117.886235000
  },
  {
    "latitude": 33.789622000,
    "longitude": -117.886127000
  },
  {
    "latitude": 33.789589000,
    "longitude": -117.886174000
  },
  {
    "latitude": 33.789491000,
    "longitude": -117.886321000
  },
  {
    "latitude": 33.789293000,
    "longitude": -117.886458000
  },
  {
    "latitude": 33.789241000,
    "longitude": -117.886328000
  },
  {
    "latitude": 33.789139000,
    "longitude": -117.886074000
  },
  {
    "latitude": 33.789115000,
    "longitude": -117.886014000
  },
  {
    "latitude": 33.788893000,
    "longitude": -117.885639000
  },
  {
    "latitude": 33.788819000,
    "longitude": -117.885531000
  },
  {
    "latitude": 33.788446000,
    "longitude": -117.884941000
  },
  {
    "latitude": 33.788366000,
    "longitude": -117.884815000
  },
  {
    "latitude": 33.788229000,
    "longitude": -117.884547000
  },
  {
    "latitude": 33.788216000,
    "longitude": -117.884521000
  },
  {
    "latitude": 33.788100000,
    "longitude": -117.884219000
  },
  {
    "latitude": 33.788014000,
    "longitude": -117.883957000
  },
  {
    "latitude": 33.787992000,
    "longitude": -117.883830000
  },
  {
    "latitude": 33.787956000,
    "longitude": -117.883695000
  },
  {
    "latitude": 33.787909000,
    "longitude": -117.883363000
  },
  {
    "latitude": 33.787901000,
    "longitude": -117.883304000
  },
  {
    "latitude": 33.787883000,
    "longitude": -117.882974000
  },
  {
    "latitude": 33.787878000,
    "longitude": -117.881727000
  },
  {
    "latitude": 33.787877000,
    "longitude": -117.881621000
  },
  {
    "latitude": 33.787874000,
    "longitude": -117.881424000
  },
  {
    "latitude": 33.787869000,
    "longitude": -117.881189000
  },
  {
    "latitude": 33.787837000,
    "longitude": -117.881017000
  },
  {
    "latitude": 33.787840000,
    "longitude": -117.880648000
  },
  {
    "latitude": 33.787840000,
    "longitude": -117.880625000
  },
  {
    "latitude": 33.787841000,
    "longitude": -117.880435000
  },
  {
    "latitude": 33.787847000,
    "longitude": -117.879556000
  },
  {
    "latitude": 33.787844000,
    "longitude": -117.879130000
  },
  {
    "latitude": 33.787844000,
    "longitude": -117.879052000
  },
  {
    "latitude": 33.787843000,
    "longitude": -117.878851000
  },
  {
    "latitude": 33.787842000,
    "longitude": -117.878720000
  },
  {
    "latitude": 33.787891000,
    "longitude": -117.878628000
  },
  {
    "latitude": 33.787891000,
    "longitude": -117.878604000
  },
  {
    "latitude": 33.787890000,
    "longitude": -117.878542000
  },
  {
    "latitude": 33.787890000,
    "longitude": -117.878380000
  },
  {
    "latitude": 33.787890000,
    "longitude": -117.878150000
  },
  {
    "latitude": 33.787890000,
    "longitude": -117.878024000
  },
  {
    "latitude": 33.787889000,
    "longitude": -117.877933000
  },
  {
    "latitude": 33.787889000,
    "longitude": -117.877739000
  },
  {
    "latitude": 33.787889000,
    "longitude": -117.877685000
  },
  {
    "latitude": 33.787888000,
    "longitude": -117.877601000
  },
  {
    "latitude": 33.787888000,
    "longitude": -117.877582000
  },
  {
    "latitude": 33.787889000,
    "longitude": -117.877097000
  },
  {
    "latitude": 33.787888000,
    "longitude": -117.876796000
  },
  {
    "latitude": 33.787888000,
    "longitude": -117.876702000
  },
  {
    "latitude": 33.787888000,
    "longitude": -117.876358000
  },
  {
    "latitude": 33.787889000,
    "longitude": -117.876046000
  },
  {
    "latitude": 33.787887000,
    "longitude": -117.875705000
  },
  {
    "latitude": 33.787887000,
    "longitude": -117.875554000
  },
  {
    "latitude": 33.787887000,
    "longitude": -117.875389000
  },
  {
    "latitude": 33.787887000,
    "longitude": -117.875270000
  },
  {
    "latitude": 33.787887000,
    "longitude": -117.875020000
  },
  {
    "latitude": 33.787886000,
    "longitude": -117.874578000
  },
  {
    "latitude": 33.787887000,
    "longitude": -117.874561000
  },
  {
    "latitude": 33.787886000,
    "longitude": -117.874423000
  },
  {
    "latitude": 33.787884000,
    "longitude": -117.873824000
  },
  {
    "latitude": 33.787884000,
    "longitude": -117.873785000
  },
  {
    "latitude": 33.787883000,
    "longitude": -117.873361000
  },
  {
    "latitude": 33.787883000,
    "longitude": -117.873275000
  },
  {
    "latitude": 33.787883000,
    "longitude": -117.873109000
  },
  {
    "latitude": 33.787883000,
    "longitude": -117.873037000
  },
  {
    "latitude": 33.787883000,
    "longitude": -117.872802000
  },
  {
    "latitude": 33.787883000,
    "longitude": -117.872633000
  },
  {
    "latitude": 33.787883000,
    "longitude": -117.872562000
  },
  {
    "latitude": 33.787883000,
    "longitude": -117.872335000
  },
  {
    "latitude": 33.787883000,
    "longitude": -117.871983000
  },
  {
    "latitude": 33.787883000,
    "longitude": -117.871711000
  },
  {
    "latitude": 33.787884000,
    "longitude": -117.871607000
  },
  {
    "latitude": 33.787883000,
    "longitude": -117.871513000
  },
  {
    "latitude": 33.787883000,
    "longitude": -117.871162000
  },
  {
    "latitude": 33.787883000,
    "longitude": -117.870965000
  },
  {
    "latitude": 33.787883000,
    "longitude": -117.870767000
  },
  {
    "latitude": 33.787883000,
    "longitude": -117.870517000
  },
  {
    "latitude": 33.787881000,
    "longitude": -117.870171000
  },
  {
    "latitude": 33.787882000,
    "longitude": -117.869975000
  },
  {
    "latitude": 33.787882000,
    "longitude": -117.869589000
  },
  {
    "latitude": 33.787886000,
    "longitude": -117.869190000
  },
  {
    "latitude": 33.787884000,
    "longitude": -117.869024000
  },
  {
    "latitude": 33.787885000,
    "longitude": -117.868824000
  },
  {
    "latitude": 33.787883000,
    "longitude": -117.868666000
  },
  {
    "latitude": 33.787881000,
    "longitude": -117.868433000
  },
  {
    "latitude": 33.787881000,
    "longitude": -117.868308000
  },
  {
    "latitude": 33.787881000,
    "longitude": -117.868222000
  },
  {
    "latitude": 33.787880000,
    "longitude": -117.868030000
  },
  {
    "latitude": 33.787880000,
    "longitude": -117.867944000
  },
  {
    "latitude": 33.787888000,
    "longitude": -117.867306000
  },
  {
    "latitude": 33.787838000,
    "longitude": -117.867107000
  },
  {
    "latitude": 33.787838000,
    "longitude": -117.866715000
  },
  {
    "latitude": 33.787838000,
    "longitude": -117.866531000
  },
  {
    "latitude": 33.787838000,
    "longitude": -117.866114000
  },
  {
    "latitude": 33.787838000,
    "longitude": -117.865902000
  },
  {
    "latitude": 33.787838000,
    "longitude": -117.865670000
  },
  {
    "latitude": 33.787881000,
    "longitude": -117.865554000
  },
  {
    "latitude": 33.787881000,
    "longitude": -117.865442000
  },
  {
    "latitude": 33.787881000,
    "longitude": -117.865167000
  },
  {
    "latitude": 33.787882000,
    "longitude": -117.865075000
  },
  {
    "latitude": 33.787882000,
    "longitude": -117.864810000
  },
  {
    "latitude": 33.787882000,
    "longitude": -117.864681000
  },
  {
    "latitude": 33.787882000,
    "longitude": -117.864622000
  },
  {
    "latitude": 33.787883000,
    "longitude": -117.864010000
  },
  {
    "latitude": 33.787883000,
    "longitude": -117.863948000
  },
  {
    "latitude": 33.787883000,
    "longitude": -117.863697000
  },
  {
    "latitude": 33.787883000,
    "longitude": -117.863160000
  },
  {
    "latitude": 33.787884000,
    "longitude": -117.862915000
  },
  {
    "latitude": 33.787884000,
    "longitude": -117.862841000
  },
  {
    "latitude": 33.787884000,
    "longitude": -117.862684000
  },
  {
    "latitude": 33.787884000,
    "longitude": -117.862405000
  },
  {
    "latitude": 33.787884000,
    "longitude": -117.862261000
  },
  {
    "latitude": 33.787885000,
    "longitude": -117.861974000
  },
  {
    "latitude": 33.787884000,
    "longitude": -117.861825000
  },
  {
    "latitude": 33.787885000,
    "longitude": -117.861692000
  },
  {
    "latitude": 33.787885000,
    "longitude": -117.861519000
  },
  {
    "latitude": 33.787886000,
    "longitude": -117.861197000
  },
  {
    "latitude": 33.787887000,
    "longitude": -117.860739000
  },
  {
    "latitude": 33.787887000,
    "longitude": -117.860435000
  },
  {
    "latitude": 33.787887000,
    "longitude": -117.860392000
  },
  {
    "latitude": 33.787888000,
    "longitude": -117.860093000
  },
  {
    "latitude": 33.787888000,
    "longitude": -117.859990000
  },
  {
    "latitude": 33.787889000,
    "longitude": -117.859655000
  },
  {
    "latitude": 33.787888000,
    "longitude": -117.859323000
  },
  {
    "latitude": 33.787888000,
    "longitude": -117.859286000
  },
  {
    "latitude": 33.787888000,
    "longitude": -117.858868000
  },
  {
    "latitude": 33.787888000,
    "longitude": -117.858716000
  },
  {
    "latitude": 33.787887000,
    "longitude": -117.858556000
  },
  {
    "latitude": 33.787887000,
    "longitude": -117.858476000
  },
  {
    "latitude": 33.787887000,
    "longitude": -117.858293000
  },
  {
    "latitude": 33.787887000,
    "longitude": -117.858081000
  },
  {
    "latitude": 33.787886000,
    "longitude": -117.857986000
  },
  {
    "latitude": 33.787846000,
    "longitude": -117.857894000
  },
  {
    "latitude": 33.787846000,
    "longitude": -117.857828000
  },
  {
    "latitude": 33.787846000,
    "longitude": -117.857771000
  },
  {
    "latitude": 33.787847000,
    "longitude": -117.857518000
  },
  {
    "latitude": 33.787848000,
    "longitude": -117.857460000
  },
  {
    "latitude": 33.787848000,
    "longitude": -117.857265000
  },
  {
    "latitude": 33.787849000,
    "longitude": -117.857090000
  },
  {
    "latitude": 33.787849000,
    "longitude": -117.857041000
  },
  {
    "latitude": 33.787891000,
    "longitude": -117.856976000
  },
  {
    "latitude": 33.787891000,
    "longitude": -117.856888000
  },
  {
    "latitude": 33.787890000,
    "longitude": -117.856602000
  },
  {
    "latitude": 33.787889000,
    "longitude": -117.856470000
  },
  {
    "latitude": 33.787889000,
    "longitude": -117.856375000
  },
  {
    "latitude": 33.787970000,
    "longitude": -117.856375000
  },
  {
    "latitude": 33.788076000,
    "longitude": -117.856372000
  },
  {
    "latitude": 33.788321000,
    "longitude": -117.856366000
  },
  {
    "latitude": 33.789279000,
    "longitude": -117.856365000
  },
  {
    "latitude": 33.789620000,
    "longitude": -117.856370000
  },
  {
    "latitude": 33.789701000,
    "longitude": -117.856365000
  },
  {
    "latitude": 33.789782000,
    "longitude": -117.856364000
  },
  {
    "latitude": 33.790351000,
    "longitude": -117.856360000
  },
  {
    "latitude": 33.791312000,
    "longitude": -117.856358000
  },
  {
    "latitude": 33.791437000,
    "longitude": -117.856363000
  },
  {
    "latitude": 33.791517000,
    "longitude": -117.856367000
  },
  {
    "latitude": 33.791598000,
    "longitude": -117.856366000
  },
  {
    "latitude": 33.793323000,
    "longitude": -117.856355000
  },
  {
    "latitude": 33.793322000,
    "longitude": -117.855591000
  },
  {
    "latitude": 33.793322000,
    "longitude": -117.855284000
  },
  {
    "latitude": 33.793310000,
    "longitude": -117.854187000
  },
  {
    "latitude": 33.793311000,
    "longitude": -117.853698000
  },
  {
    "latitude": 33.793311000,
    "longitude": -117.853367000
  },
  {
    "latitude": 33.793311000,
    "longitude": -117.853212000
  },
  {
    "latitude": 33.793311000,
    "longitude": -117.853097000
  },
  {
    "latitude": 33.793315000,
    "longitude": -117.852996000
  },
  {
    "latitude": 33.793316000,
    "longitude": -117.852810000
  },
  {
    "latitude": 33.793325000,
    "longitude": -117.852810000
  }
]    
"""

extension Mock {
    static var mapRouteMock: [Mock<Coordinates>] {
        guard let jsonData = mapRouteMockJSONArray.data(using: .utf8) else {
            return []
        }
        
        do {
            let coordinatesArray = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [[String: Any]]
            
            return coordinatesArray?.compactMap { coordinateDict in
                guard let latitude = coordinateDict["latitude"] as? Double,
                      let longitude = coordinateDict["longitude"] as? Double else {
                    return nil
                }
                
                return Mock<Coordinates>(
                    latitude: latitude,
                    longitude: longitude
                )
            } ?? []
        } catch {
            return []
        }
    }
}
