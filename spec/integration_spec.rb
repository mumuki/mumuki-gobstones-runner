require 'active_support/all'
require 'mumukit/bridge'

describe 'Server' do

  let(:bridge) { Mumukit::Bridge::Runner.new('http://localhost:4568') }

  before(:all) do
    @pid = Process.spawn 'rackup -p 4568', err: '/dev/null'
    sleep 8
  end

  after(:all) { Process.kill 'TERM', @pid }

  let(:test) {
    %q{
examples:
- initial_board: |
    GBB/1.0
    size 3 3
    head 0 0
  final_board: |
    GBB/1.0
    size 3 3
    head 0 1
- initial_board: |
    GBB/1.0
    size 2 2
    head 0 0
  final_board: |
    GBB/1.0
    size 2 2
    head 0 1
}}

  it 'bug' do
    response = bridge.run_tests!(
      content: "<xml xmlns=\"http://www.w3.org/1999/xhtml\"><variables></variables><block type=\"procedures_defnoreturnnoparams\" id=\"cX7hx2knA^8e6c]%+}Y7\" x=\"-48\" y=\"-422\"><field name=\"NAME\">Atacar asteroide</field><statement name=\"STACK\"><block type=\"AlternativaCompleta\" id=\"PEs5ypzgTTyK^CO[d75c\"><mutation elseif=\"2\" else=\"1\"></mutation><value name=\"condicion\"><block type=\"OperadorLogico\" id=\"Qmyi.nCE7yFprO|OdqAz\"><field name=\"OPERATOR\">AND</field><value name=\"arg1\"><block type=\"estaLejos\" id=\"A$rN$;ndvS|,;bY1t$,y\"></block></value><value name=\"arg2\"><block type=\"vieneLento\" id=\")8%!a|(Tv*z(2WC7ME^k\"></block></value></block></value><statement name=\"block1\"><block type=\"IrAlBorde\" id=\"%|;6g}qDOFWv8]FmKtvO\"><value name=\"DIRECCION\"><block type=\"DireccionSelector\" id=\"q6;2Z4jh8,UwrR0cXVRk\"><field name=\"DireccionDropdown\">Norte</field></block></value><next><block type=\"IrAlBorde\" id=\"YP#?TZAN-?#?J2-?up$y\"><value name=\"DIRECCION\"><block type=\"DireccionSelector\" id=\"FnJW]aDz2VG.%4D[U|O6\"><field name=\"DireccionDropdown\">Este</field></block></value><next><block type=\"PonerTractorGravitacional\" id=\"c$5`.VDJ9k)$9yMiW98P\"></block></next></block></next></block></statement><value name=\"IF1\"><block type=\"OperadorLogico\" id=\"vcysu|A$;U*~f7(=K7wR\"><field name=\"OPERATOR\">AND</field><value name=\"arg1\"><block type=\"estaLejos\" id=\"~BNvRY)*hwfcA|m[{?A=\"></block></value><value name=\"arg2\"><block type=\"vieneRapido\" id=\"5-iJRT=GR#hbG=#PELmE\"></block></value></block></value><statement name=\"DO1\"><block type=\"IrALaEstacion\" id=\"reo5k,)^gO{SU0^6e^_I\"><next><block type=\"EnviarConductorAl_\" id=\"2u#[!N[]4.x^yCcJW(bU\"><value name=\"arg1\"><block type=\"DireccionSelector\" id=\"jNqrOz`y]LiMI^|}Gp*I\"><field name=\"DireccionDropdown\">Norte</field></block></value><next><block type=\"EnviarConductorAl_\" id=\"[l6LaL;cU{}eCT3bt`s_\"><value name=\"arg1\"><block type=\"DireccionSelector\" id=\"#SI3tMB=.!!V9N!Fv5eK\"><field name=\"DireccionDropdown\">Norte</field></block></value><next><block type=\"EnviarConductorAl_\" id=\"o2;3:5luu7v.~!Ua?d%6\"><value name=\"arg1\"><block type=\"DireccionSelector\" id=\"1Fq3.]sD+AH$SK,DHq.Y\"><field name=\"DireccionDropdown\">Oeste</field></block></value><next><block type=\"Perforar\" id=\"wJ~oSC?a*XQ)oIAjZP+N\"></block></next></block></next></block></next></block></next></block></statement><value name=\"IF2\"><block type=\"OperadorLogico\" id=\"RaajotS]5bU1|UQY=3Jy\"><field name=\"OPERATOR\">AND</field><value name=\"arg1\"><block type=\"estaCerca\" id=\"nV4WOoMVd#Eh6{:i~]D7\"></block></value><value name=\"arg2\"><block type=\"vieneLento\" id=\"]_FT;k4sSCq_w*M^7,?=\"></block></value></block></value><statement name=\"DO2\"><block type=\"IrALaEstacion\" id=\"OX=ayqP5BTmATtS9VJ5h\"><next><block type=\"EnviarPropulsorAl_\" id=\"-+cmxrhHaLx^aD(P:?%C\"><value name=\"arg1\"><block type=\"DireccionSelector\" id=\"[SqQlL.kc^Ipw[.S+bFv\"><field name=\"DireccionDropdown\">Norte</field></block></value><next><block type=\"EnviarPropulsorAl_\" id=\"|PuzgK{tnf3OfJU*hMaQ\"><value name=\"arg1\"><block type=\"DireccionSelector\" id=\";^9b[:*e?:=Rc{oFs?a:\"><field name=\"DireccionDropdown\">Oeste</field></block></value><next><block type=\"RepeticionCondicional\" id=\"s+pm+b64v%Bui-bnC2kD\"><value name=\"condicion\"><block type=\"puedeMoverAsteroide\" id=\".-t-3-cq^(9J1e[W6bYP\"></block></value><statement name=\"block\"><block type=\"AumentarPotencia\" id=\"nGJ*Z+gj#N]v^7q)9fWi\"></block></statement></block></next></block></next></block></next></block></statement><statement name=\"block2\"><block type=\"InvestigarNuevoMétodoDeDefensa\" id=\"(wr_z1BRMTkLtb!;M,1o\"></block></statement></block></statement></block><block type=\"Program\" id=\"=#5rfU^c=,c+jYKw[Lmu\" deletable=\"false\" x=\"-256\" y=\"-313\"><mutation timestamp=\"1556038796698\"></mutation><statement name=\"program\"><block type=\"procedures_callnoreturnnoparams\" id=\"6_5t}?f}f]P#QZoDDjhA\"><mutation name=\"Atacar asteroide\"></mutation></block></statement></block></xml>",
      extra: '<xml xmlns="http://www.w3.org/1999/xhtml"><variables><variable type="" id="]GvX~$WS-.%o#,!15O0^">dir</variable><variable type="" id="ACJ.Q1)a1^%%rxEI~](Y">dir2</variable></variables><block type="procedures_defnoreturnnoparams" id="!#IFetHaq%|.Q3nj4T3d" x="-1618" y="-415"><field name="NAME">Ir a la estacion</field><statement name="STACK"><block type="IrAlBorde" id="Q,G`7N|}7u_-xyGnM+hM"><value name="DIRECCION"><block type="DireccionSelector" id="?#`k(V8cvTeCkJJo,3Iw"><field name="DireccionDropdown">Sur</field></block></value><next><block type="IrAlBorde" id=",Ybe[y1=MY;]oX1aRpp="><value name="DIRECCION"><block type="DireccionSelector" id="fZRRL_j^p_YXUUm_e?pm"><field name="DireccionDropdown">Oeste</field></block></value><next><block type="Mover" id=".zx`XtiesV;w6?Y{qEw."><value name="DIRECCION"><block type="DireccionSelector" id="eBDaZmx68.uaHmzLrXu^"><field name="DireccionDropdown">Este</field></block></value></block></next></block></next></block></statement></block><block type="procedures_defnoreturnnoparams" id="n3+z,w1~;R1}*dxt1w{:" x="-1812" y="-365"><field name="NAME">Investigar nuevo método de defensa</field></block><block type="procedures_defnoreturn" id=":uq:8ulk4(ir8j1{Nl,^" x="-1826" y="-232"><mutation><arg name="dir"></arg></mutation><field name="NAME">Enviar conductor al_</field><field name="ARG0">dir</field><statement name="STACK"><block type="Sacar" id="Sv=#CyY8`MR,!SayU?`h"><value name="COLOR"><block type="ColorSelector" id="4Fr}c9vQx|=qtG7z$~w;"><field name="ColorDropdown">Rojo</field></block></value><next><block type="Mover" id="cGiaXY`vn-x.IvAVih`i"><value name="DIRECCION"><block type="variables_get" id="Yrp(0Eadd+c7D]FyN`4t"><mutation var="dir" parent=":uq:8ulk4(ir8j1{Nl,^"></mutation></block></value><next><block type="Poner" id="%.;v}GMM5keWj8Vfr.M!"><value name="COLOR"><block type="ColorSelector" id=":t3wAuPN%Pi;Y!qi1SQ%"><field name="ColorDropdown">Rojo</field></block></value></block></next></block></next></block></statement></block><block type="procedures_defnoreturnnoparams" id="7MxBH5]YBkYq(DV^9{Yt" x="-1533" y="-239"><field name="NAME">Poner tractor gravitacional</field><statement name="STACK"><block type="Poner" id="?aRy$}gynX2rK#%|-W~a"><value name="COLOR"><block type="ColorSelector" id="L(l2]WT$E(=uo$P{(Wdw"><field name="ColorDropdown">Rojo</field></block></value><next><block type="Poner" id="$Unx*=k89fF-Ia.22#r{"><value name="COLOR"><block type="ColorSelector" id="wWG7F-%Dt9[Y~D$AOPa`"><field name="ColorDropdown">Rojo</field></block></value><next><block type="procedures_callnoreturnnoparams" id="`}A([fB5XqthWH?J9NbO"><mutation name="Atraer asteroide"></mutation></block></next></block></next></block></statement></block><block type="procedures_defnoreturn" id="p[^UTlMI6SH+U,yPl{ds" x="-1219" y="-237"><mutation><arg name="dir"></arg></mutation><field name="NAME">Enviar impactador al_</field><field name="ARG0">dir</field><statement name="STACK"><block type="RepeticionSimple" id="]B0NS1U,SZLy`a+iKd~i"><value name="count"><block type="math_number" id="WPv[qu,D7}prDZH))}9e"><field name="NUM">3</field></block></value><statement name="block"><block type="Sacar" id="tybLeqSoO1chJ#Q:8h[5"><value name="COLOR"><block type="ColorSelector" id="+]jeSe6gas)Ye44cpGr%"><field name="ColorDropdown">Rojo</field></block></value></block></statement><next><block type="Mover" id="X]I7m~:u2Gh?xy6CJ=lK"><value name="DIRECCION"><block type="variables_get" id="$NxiM]y|UD^Ws(;5H6o}"><mutation var="dir" parent="p[^UTlMI6SH+U,yPl{ds"></mutation></block></value><next><block type="RepeticionSimple" id="TE9g9G_RL_y7+Qp]VIXw"><value name="count"><block type="math_number" id="Qqo9GYlgMF.Q,#jg|+-~"><field name="NUM">3</field></block></value><statement name="block"><block type="Poner" id="?x.srlAtf|37cb;()7o6"><value name="COLOR"><block type="ColorSelector" id="7I#S0EH(*?.Y]C]YVAQ="><field name="ColorDropdown">Rojo</field></block></value></block></statement></block></next></block></next></block></statement></block><block type="procedures_defreturnsimple" id="PDU9c8v59A6{azRB_bEF" x="-920" y="-237"><mutation statements="false"></mutation><field name="NAME">esta lejos</field><value name="RETURN"><block type="OperadorLogico" id="hVa8-1u!ja|Pg?w3D!wn"><field name="OPERATOR">||</field><value name="arg1"><block type="OperadorDeComparacion" id="nf}?dMX*?#IF?K5]BZl9"><field name="RELATION">==</field><value name="arg1"><block type="nroBolitas" id=";HDL^g9xajOh?MPaUHZz"><value name="VALUE"><block type="ColorSelector" id="C`X_7^rv0GN2Yy]Mmv$["><field name="ColorDropdown">Verde</field></block></value></block></value><value name="arg2"><block type="math_number" id="aerz)2#BvetPxNDUFz.e"><field name="NUM">1</field></block></value></block></value><value name="arg2"><block type="OperadorDeComparacion" id="2e#WFBLkWu?=2P0I;le^"><field name="RELATION">==</field><value name="arg1"><block type="nroBolitas" id="p)Uhva{HadFyv?s*E1XK"><value name="VALUE"><block type="ColorSelector" id="pECYw122ot~%3y+ea=Eg"><field name="ColorDropdown">Verde</field></block></value></block></value><value name="arg2"><block type="math_number" id=":$}`2Egv8TTr7rUAzoSp"><field name="NUM">2</field></block></value></block></value></block></value></block><block type="procedures_defreturnsimple" id="2:;-E=nL:E**LKREmuEz" x="-289" y="-194"><mutation statements="false"></mutation><field name="NAME">viene lento</field><value name="RETURN"><block type="OperadorLogico" id="X%3Vr)fI)~zF3a(*Ao)b"><field name="OPERATOR">||</field><value name="arg1"><block type="OperadorDeComparacion" id="pYvL?FKJDM(94Y:S^Faw"><field name="RELATION">==</field><value name="arg1"><block type="nroBolitas" id="vohV5BsoA}h1`{V$u=lK"><value name="VALUE"><block type="ColorSelector" id="$St5d?bJUaP=i0Lq!]P+"><field name="ColorDropdown">Verde</field></block></value></block></value><value name="arg2"><block type="math_number" id="d.YA0d8kBnTlEwnlj)IE"><field name="NUM">1</field></block></value></block></value><value name="arg2"><block type="OperadorDeComparacion" id="*PHzRQgFXG9O)MQ79Nzz"><field name="RELATION">==</field><value name="arg1"><block type="nroBolitas" id="}?,hMsFaaX_+sl6lSNZ9"><value name="VALUE"><block type="ColorSelector" id="=!z?q*}Rga(I3Bg_JDBX"><field name="ColorDropdown">Verde</field></block></value></block></value><value name="arg2"><block type="math_number" id="(DJKnlMxV%~Ch[!Z.YA`"><field name="NUM">3</field></block></value></block></value></block></value></block><block type="procedures_defnoreturnnoparams" id="G-``Lao%N10b(gj[%D72" x="-1532" y="-89"><field name="NAME">Atraer asteroide</field><statement name="STACK"><block type="procedures_callnoreturn" id="Y$YFq.-:YOLQxUqu]B2T"><mutation name="Mover en L"><arg name="dir"></arg><arg name="dir2"></arg></mutation><value name="ARG0"><block type="DireccionSelector" id="P{,,,~t~S}0aNpvvi:}Z"><field name="DireccionDropdown">Oeste</field></block></value><value name="ARG1"><block type="DireccionSelector" id="XuapjlChj^pEv|!Y`{F_"><field name="DireccionDropdown">Sur</field></block></value><next><block type="Sacar" id="u(8x}0OwehHppv#o.ZgQ"><value name="COLOR"><block type="ColorSelector" id="z6ep0LolM;!FV)~97N1p"><field name="ColorDropdown">Verde</field></block></value><next><block type="procedures_callnoreturn" id="mdY{y.gj5[P^B2n=ru(4"><mutation name="Mover en L"><arg name="dir"></arg><arg name="dir2"></arg></mutation><value name="ARG0"><block type="DireccionSelector" id="o$}Vs]zR{#a^tX]-PT!N"><field name="DireccionDropdown">Este</field></block></value><value name="ARG1"><block type="DireccionSelector" id="MW43_}OirddD9+cs5dw~"><field name="DireccionDropdown">Norte</field></block></value><next><block type="Poner" id="#q2oo!JB0OQb6BNW;I!-"><value name="COLOR"><block type="ColorSelector" id=")U?-zqERp}j)]P(w,K5:"><field name="ColorDropdown">Verde</field></block></value></block></next></block></next></block></next></block></statement></block><block type="procedures_defnoreturnnoparams" id="N5f3M~-DyIEdjGEQ(?,(" x="-1822" y="-32"><field name="NAME">Perforar</field><statement name="STACK"><block type="Sacar" id=":tVnV;-y4+PDYd5+4yt{"><value name="COLOR"><block type="ColorSelector" id="Da?-0AqLOl[J!#JJ`Ji-"><field name="ColorDropdown">Rojo</field></block></value><next><block type="Sacar" id=".?eagZbj`[Dr=0$x]4;Y"><value name="COLOR"><block type="ColorSelector" id="!Pl6tR;e;LaYkNNdXK3Q"><field name="ColorDropdown">Verde</field></block></value><next><block type="Sacar" id="?Ty7i)%aW?]B{i;iTRth"><value name="COLOR"><block type="ColorSelector" id="+Z76t.G(R56Bs10%Iujj"><field name="ColorDropdown">Verde</field></block></value><next><block type="Mover" id=".:[d9ar[28J6HQsW2j?o"><value name="DIRECCION"><block type="DireccionSelector" id="f*|f2JHRJh7{*T0nsCo]"><field name="DireccionDropdown">Norte</field></block></value><next><block type="Poner" id=",uke5_{NNHhRy5X.K%l#"><value name="COLOR"><block type="ColorSelector" id="AGIaW?~fkp)O;]^ZV9L4"><field name="ColorDropdown">Rojo</field></block></value><next><block type="Poner" id="Tp:y`YEs4xx.O1(!G-oC"><value name="COLOR"><block type="ColorSelector" id="r5ymmn|4#eoWg#tJ|REM"><field name="ColorDropdown">Verde</field></block></value><next><block type="Poner" id="LnZt$+UYZMzCo]O0I6{)"><value name="COLOR"><block type="ColorSelector" id="}.z}nmUBoPLNo)KWu6#M"><field name="ColorDropdown">Verde</field></block></value></block></next></block></next></block></next></block></next></block></next></block></next></block></statement></block><block type="procedures_defreturnsimple" id="vTdM}v8nx$(vdk-.*d^U" x="-919" y="16"><mutation statements="false"></mutation><field name="NAME">esta cerca</field><value name="RETURN"><block type="OperadorLogico" id="4+?.aCmq0pnbs0cA7~Y|"><field name="OPERATOR">||</field><value name="arg1"><block type="OperadorDeComparacion" id="Eta[NPyZ#MBZPRBb]J?I"><field name="RELATION">==</field><value name="arg1"><block type="nroBolitas" id=".9;5x+7wT-qvPI+HHby["><value name="VALUE"><block type="ColorSelector" id="NXST8gN)qBoGR*;Q)de%"><field name="ColorDropdown">Verde</field></block></value></block></value><value name="arg2"><block type="math_number" id="4Ij:+f0[-%RKw$D5g0.O"><field name="NUM">3</field></block></value></block></value><value name="arg2"><block type="OperadorDeComparacion" id="r.vkewhhj1)5a:NByxlE"><field name="RELATION">==</field><value name="arg1"><block type="nroBolitas" id="Oy1,eff^?sO$[qtzai_3"><value name="VALUE"><block type="ColorSelector" id="X!+6u:-^Au4lkn,0BGeT"><field name="ColorDropdown">Verde</field></block></value></block></value><value name="arg2"><block type="math_number" id="Xijsd3%[Vp7K^`n+o+[0"><field name="NUM">4</field></block></value></block></value></block></value></block><block type="procedures_defnoreturn" id="MJ1x)!E~DZcTVh1ovV3I" x="-1222" y="72"><mutation><arg name="dir"></arg></mutation><field name="NAME">Enviar propulsor al_</field><field name="ARG0">dir</field><statement name="STACK"><block type="RepeticionSimple" id=",O}w%duyG(eY3{XxBj]g"><value name="count"><block type="math_number" id="PXx9I5eK8J+u;Z}p)KEk"><field name="NUM">2</field></block></value><statement name="block"><block type="Sacar" id="`Oxc!3BLxLH8##}-*,GU"><value name="COLOR"><block type="ColorSelector" id="-.~[$.pE?K]w}O8RMV7G"><field name="ColorDropdown">Rojo</field></block></value></block></statement><next><block type="Mover" id="]#!yCSI)2USdyXg{(4Wv"><value name="DIRECCION"><block type="variables_get" id="5EVoU69Q2f88*X6ObMBF"><mutation var="dir" parent="MJ1x)!E~DZcTVh1ovV3I"></mutation></block></value><next><block type="RepeticionSimple" id="$_tY4$.oosAr%a!ADrX;"><value name="count"><block type="math_number" id="+G9jZ0dJO=NXE#fmfa1+"><field name="NUM">2</field></block></value><statement name="block"><block type="Poner" id="RA1=|Hwzmx4Mmy-~XLuV"><value name="COLOR"><block type="ColorSelector" id="|b#|S)fP73`]Xs,G492S"><field name="ColorDropdown">Rojo</field></block></value></block></statement></block></next></block></next></block></statement></block><block type="procedures_defnoreturn" id="OEzDx:8?Dv2G6_,swZ|3" x="-1525" y="203"><mutation><arg name="dir"></arg><arg name="dir2"></arg></mutation><field name="NAME">Mover en L</field><field name="ARG0">dir</field><field name="ARG1">dir2</field><statement name="STACK"><block type="Mover" id="}.mqZYq{dp3]lKMwt8LT"><value name="DIRECCION"><block type="variables_get" id=".0$Ur-%}aW!guYUnf4|q"><mutation var="dir" parent="OEzDx:8?Dv2G6_,swZ|3"></mutation></block></value><next><block type="Mover" id="_Eja^wt3%W?Vp80M!kzk"><value name="DIRECCION"><block type="variables_get" id="4aETN=!~~wrK9+D)RxH0"><mutation var="dir" parent="OEzDx:8?Dv2G6_,swZ|3"></mutation></block></value><next><block type="Mover" id="Jle(FE$-(%$wyaR|no?F"><value name="DIRECCION"><block type="variables_get" id="1]rgu9vs1TgJ7ep32^=n"><mutation var="dir2" parent="OEzDx:8?Dv2G6_,swZ|3"></mutation></block></value></block></next></block></next></block></statement></block><block type="procedures_defreturnsimple" id="T+E=;M*CcHensgNC0FR|" x="-920" y="255"><mutation statements="false"></mutation><field name="NAME">viene rapido</field><value name="RETURN"><block type="OperadorLogico" id="JMsj1epGN4EhvPUlTaH?"><field name="OPERATOR">||</field><value name="arg1"><block type="OperadorDeComparacion" id="uDoly)G~{!g6UT,PJa[q"><field name="RELATION">==</field><value name="arg1"><block type="nroBolitas" id="x2t6,ZDYZ?nca#urirR)"><value name="VALUE"><block type="ColorSelector" id="iiIK{2~8,.x$b7Hgo-LD"><field name="ColorDropdown">Verde</field></block></value></block></value><value name="arg2"><block type="math_number" id="mR{M-~1}pfE*{c~DGQXa"><field name="NUM">4</field></block></value></block></value><value name="arg2"><block type="OperadorDeComparacion" id="~9f{14w]fwiLJwrS(~iW"><field name="RELATION">==</field><value name="arg1"><block type="nroBolitas" id="myaoQ4gmJL3!`gAp1Kc,"><value name="VALUE"><block type="ColorSelector" id="-%a:d)SVMh-Wi3xZ6KVc"><field name="ColorDropdown">Verde</field></block></value></block></value><value name="arg2"><block type="math_number" id="#PtmuY8GHb(6w6ZqOHbb"><field name="NUM">2</field></block></value></block></value></block></value></block><block type="procedures_defnoreturnnoparams" id="1k]aj2`Z3(-lBF`01**Y" x="-1820" y="314"><field name="NAME">Empujar asteroide</field><statement name="STACK"><block type="RepeticionSimple" id="gM{OCcf7iK7n54|7|tli"><value name="count"><block type="math_number" id="Syvd,ZnD7WS-UB*7_V[7"><field name="NUM">2</field></block></value><statement name="block"><block type="Sacar" id="nU_FXEV:Is2P6k3)b~Cd"><value name="COLOR"><block type="ColorSelector" id="[c|(]FhUzOs:_syw;,Tq"><field name="ColorDropdown">Rojo</field></block></value><next><block type="Sacar" id="(:=?4tkuIVnOUjdDxC.i"><value name="COLOR"><block type="ColorSelector" id="KM;0=G6*6~M1=vo-.u.m"><field name="ColorDropdown">Negro</field></block></value><next><block type="Sacar" id="P3l?1*^00%dv7dg=j:ny"><value name="COLOR"><block type="ColorSelector" id="hybY-B0!S+lE1+HAZqS6"><field name="ColorDropdown">Negro</field></block></value><next><block type="Sacar" id="]FGLhRE:O`f-BUFk`Yb1"><value name="COLOR"><block type="ColorSelector" id=",siaB8?pe#qXx+`K3BV0"><field name="ColorDropdown">Verde</field></block></value></block></next></block></next></block></next></block></statement><next><block type="Sacar" id="%ft},f75E7z(_Z~0i6eb"><value name="COLOR"><block type="ColorSelector" id="QFu+5`aWrD1L+a%rfv=B"><field name="ColorDropdown">Verde</field></block></value><next><block type="Mover" id="p#48hT~sx1H3r=$NmZra"><value name="DIRECCION"><block type="DireccionSelector" id="$HRYUT:hLsQ]0T(R)e=!"><field name="DireccionDropdown">Norte</field></block></value><next><block type="Mover" id="(H}K86-Z=8IdT(8D^6HX"><value name="DIRECCION"><block type="DireccionSelector" id="2.dZP]hA3?)52vuztk,e"><field name="DireccionDropdown">Norte</field></block></value><next><block type="RepeticionSimple" id="C1R;6R1g*7o=Jo[_#Yrf"><value name="count"><block type="math_number" id="??PJ8|imw7*wm%I]QxLG"><field name="NUM">2</field></block></value><statement name="block"><block type="Poner" id="6]_0t^`w$8p`a0ha!D(e"><value name="COLOR"><block type="ColorSelector" id="BPr).oEZve?(F5pf;)=P"><field name="ColorDropdown">Rojo</field></block></value><next><block type="Poner" id="rN:^a:ObtDa{Um4x4D3a"><value name="COLOR"><block type="ColorSelector" id="$6-i`UxbB:oao%:*%GT="><field name="ColorDropdown">Negro</field></block></value><next><block type="Poner" id="cqj+4`2(QBJ:Siw-r5;Y"><value name="COLOR"><block type="ColorSelector" id="!uZ$uCOXJX%#m3:.u|;="><field name="ColorDropdown">Negro</field></block></value><next><block type="Poner" id="eyaf%UnmMWJ;CIXqT*zw"><value name="COLOR"><block type="ColorSelector" id="exdRCaayoKP6qrkb*C_K"><field name="ColorDropdown">Verde</field></block></value></block></next></block></next></block></next></block></statement><next><block type="Poner" id="4GwUB|$VoFgt|?:GqQJ("><value name="COLOR"><block type="ColorSelector" id="I?^xf?:QZMKH#{np+io7"><field name="ColorDropdown">Verde</field></block></value></block></next></block></next></block></next></block></next></block></next></block></statement></block><block type="procedures_defnoreturnnoparams" id="(cSy:B5;s)v`3TPQFF??" x="-1222" y="363"><field name="NAME">Aumentar potencia</field><statement name="STACK"><block type="Poner" id="z#k(q9xKnI?W~CQwg8}C"><value name="COLOR"><block type="ColorSelector" id="8aM2#caEU7f*19[)pxnb"><field name="ColorDropdown">Negro</field></block></value><next><block type="AlternativaSimple" id="9|_-JAi=[(=Qpjm^JFc3"><value name="condicion"><block type="procedures_callreturnsimple" id="dAn(v28q+kQ=eO4C,OWK"><mutation name="puede mover asteroide"></mutation></block></value><statement name="block"><block type="procedures_callnoreturnnoparams" id="e{RBOl6]3c$_?CZ#eB1O"><mutation name="Empujar asteroide"></mutation></block></statement></block></next></block></statement></block><block type="procedures_defreturnsimple" id="LyGq+;6X+2,ZUHol08K." x="-1517" y="560"><mutation statements="false"></mutation><field name="NAME">puede mover asteroide</field><value name="RETURN"><block type="OperadorDeComparacion" id="s2AN56$Q.zSw=nxESa;m"><field name="RELATION">==</field><value name="arg1"><block type="nroBolitas" id="re4(M*$4!P:GHHPh^}+B"><value name="VALUE"><block type="ColorSelector" id="}BqDAUhA?apesmJLUHH_"><field name="ColorDropdown">Negro</field></block></value></block></value><value name="arg2"><block type="math_number" id="|oa$$h4YP2MB$aM#^ry1"><field name="NUM">4</field></block></value></block></value></block></xml>',
      expectations: [],
      test: '
check_head_position: false
interactive: true
examples:
  - initial_board: |
      GBB/1.0
      size 5 5
      cell 0 0 Azul 1
      head 0 0
    final_board: |
      GBB/1.0
      size 5 5
      head 0 0
    ')

    expect(response).to eq response_type: :unstructured,
                           status: :passed,
                           feedback: '',
                           expectation_results: [],
                           test_results: [],
                           result: ''
  end

  it 'answers a valid hash when submission passes' do
    response = bridge.run_tests!(test: test, extra: '', content: %q{
program {
  Mover(Norte)
}}, expectations: [])

    expect(response[:status]).to eq :passed
    expect(response[:test_results].size).to eq 2
    expect(response[:response_type]).to eq :structured
  end

  it 'answers a valid hash when submission passes and boards do not have a GBB spec' do
    response = bridge.run_tests!(test: %q{
examples:
- initial_board: |
    size 3 3
    head 0 0
  final_board: |
      size 3 3
      head 0 1}, extra: '', content: %q{
program {
  Mover(Norte)
}}, expectations: [])

    expect(response[:status]).to eq :passed
    expect(response[:response_type]).to eq :structured
  end

  it 'answers a valid hash when submission passes, with expectations' do
    response = bridge.run_tests!(
      content: '
procedure PonerUnaDeCada() {
    Poner (Rojo)
    Poner (Azul)
    Poner (Negro)
    Poner (Verde)
}',
      extra: '',
      expectations: [
        {binding: 'program', inspection: 'HasUsage:PonerUnaDecada'},
        {binding: 'program', inspection: 'Not:HasBinding'},
      ],
      test: '
check_head_position: true

subject: PonerUnaDeCada

examples:
 - initial_board: |
     GBB/1.0
     size 4 4
     head 0 0
   final_board: |
     GBB/1.0
     size 4 4
     cell 0 0 Azul 1 Rojo 1 Verde 1 Negro 1
     head 0 0

 - initial_board: |
     GBB/1.0
     size 5 5
     head 3 3
   final_board: |
     GBB/1.0
     size 5 5
     cell 3 3 Azul 1 Rojo 1 Verde 1 Negro 1
     head 3 3')

    expect(response.except(:test_results)).to eq response_type: :structured,
                                                 status: :passed_with_warnings,
                                                 feedback: '',
                                                 expectation_results: [
                                                   {binding: "program", inspection: "Uses:=PonerUnaDecada", result: :failed},
                                                   {binding: "*", inspection: "Not:Declares:=program", result: :passed},
                                                   {binding: "*", inspection: "Declares:=PonerUnaDeCada", result: :passed}
                                                 ],
                                                 result: ''
    expect(response[:test_results].size).to eq 2
  end

  it 'executes each test with the proper argument' do
    response = bridge.run_tests!(
      content: '
procedure PonerUna(color) {
    Poner (color)
}',
      extra: '',
      expectations: [
      ],
      test: '
check_head_position: true

subject: PonerUna

examples:

 - arguments:
   - Rojo
   initial_board: |
     GBB/1.0
     size 4 4
     head 0 0
   final_board: |
     GBB/1.0
     size 4 4
     cell 0 0 Rojo 1
     head 0 0

 - arguments:
   - Azul
   initial_board: |
     GBB/1.0
     size 5 5
     head 3 3
   final_board: |
     GBB/1.0
     size 5 5
     cell 3 3 Azul 1
     head 3 3')

    expect(response[:test_results].pluck(:status)).to eq [:passed, :passed]
    expect(response.except(:test_results)).to eq response_type: :structured,
                                                 status: :passed,
                                                 feedback: '',
                                                 expectation_results: [
                                                   {:binding=>"*", :inspection=>"Declares:=PonerUna", :result=>:passed}
                                                 ],
                                                 result: ''
  end

  it 'produces a faied when the header position does not match but there were no changes in the board' do
    response = bridge.run_tests!(
      content: '
procedure MoverConCuidado(color) {
    Mover(Norte)
    Mover(Este)
}',
      extra: '',
      expectations: [],
      test: '
check_head_position: true

subject: MoverConCuidado

examples:

 - arguments:
   - Rojo
   initial_board: |
     GBB/1.0
     size 4 4
     cell 0 0 Rojo 1
     head 0 0
   final_board: |
     GBB/1.0
     size 4 4
     cell 0 0 Rojo 1
     head 2 0

 - arguments:
   - Azul
   initial_board: |
     GBB/1.0
     size 5 5
     cell 0 0 Rojo 1
     head 0 0
   final_board: |
     GBB/1.0
     size 5 5
     cell 0 0 Rojo 1
     head 2 0')

    expect(response[:test_results].pluck(:status)).to eq [:failed, :failed]
    expect(response.except(:test_results)).to eq response_type: :structured,
                                                 status: :failed,
                                                 feedback: '',
                                                 expectation_results: [
                                                   {:binding=>"*", :inspection=>"Declares:=MoverConCuidado", :result=>:passed}
                                                 ],
                                                 result: ''
  end

  it 'produces a passed_with_warnings when the header position does not match and there were changesin the board' do
    response = bridge.run_tests!(
      content: '
procedure PonerUna(color) {
    Poner (color) ; Mover(Este)
}',
      extra: '',
      expectations: [
      ],
      test: '
check_head_position: true

subject: PonerUna

examples:

 - arguments:
   - Rojo
   initial_board: |
     GBB/1.0
     size 4 4
     head 0 0
   final_board: |
     GBB/1.0
     size 4 4
     cell 0 0 Rojo 1
     head 0 0

 - arguments:
   - Azul
   initial_board: |
     GBB/1.0
     size 5 5
     head 3 3
   final_board: |
     GBB/1.0
     size 5 5
     cell 3 3 Azul 1
     head 3 3')

    expect(response[:test_results].pluck(:status)).to eq [:passed, :passed]
    expect(response.except(:test_results)).to eq response_type: :structured,
                                                 status: :passed_with_warnings,
                                                 feedback: '',
                                                 expectation_results: [
                                                   {:binding=>"*", :inspection=>"Declares:=PonerUna", :result=>:passed},
                                                   {:binding=>"*", :inspection=>"HeadPositionMatch", :result=>:false}
                                                 ],
                                                 result: ''
  end

  it 'answers a valid hash when submission is aborted and expected' do
    response = bridge.run_tests!(
      content: '
procedure HastaElInfinito() {
  while (puedeMover(Este)) {
    Poner(Rojo)
  }
}',
      extra: '',
      expectations: [
        {binding: "program", inspection: "Not:HasBinding"},
      ],
      test: '
subject: HastaElInfinito
expect_endless_while: true
examples:
 - initial_board: |
     GBB/1.0
     size 2 2
     head 0 0
   final_board: |
     GBB/1.0
     size 2 2
     head 0 0')

    expect(response.except(:test_results)).to eq response_type: :structured,
                                                 status: :passed,
                                                 feedback: '',
                                                 expectation_results: [
                                                   {binding: "*", inspection: "Not:Declares:=program", result: :passed},
                                                   {binding: "*", inspection: "Declares:=HastaElInfinito", result: :passed}
                                                 ],
                                                 result: ''
  end

  it 'answers a valid hash when the expected boom type is wrong_argument_type' do
    response = bridge.run_tests!(
      content: "program {\nDibujarLinea3(Este, Verde)\nMover(Este)\nDibujarLinea3(Norte, Rojo)\nMover(Norte)\nDibujarLinea3(Oeste, Negro)\nMover(Oeste)\nDibujarLinea3(Sur, Azul)\n}",
      extra: "procedure DibujarLinea3(color, direccion) {\n repeat(color) {\n  Poner(color)\n  Mover(direccion)\n  Poner(color)\n  Mover(direccion)\n  Poner(color)\n }\n }",
      expectations: [],
      test: "check_head_position: true\n\nexamples:\n - title: '¡BOOM!'\n   initial_board: |\n     GBB/1.0\n     size 3 3\n     head 0 0\n   error: wrong_argument_type")

    expect(response[:status]).to eq :passed
    expect(response[:response_type]).to eq :structured
  end

  it 'answers a valid hash when the expected boom type is wrong_argument_type' do
    response = bridge.run_tests!(
      content: "program {\nDibujarLinea3(Este, Verde)\nMover(Este)\nDibujarLinea3(Norte, Rojo)\nMover(Norte)\nDibujarLinea3(Oeste, Negro)\nMover(Oeste)\nDibujarLinea3(Sur, Azul)\n}",
      extra: "procedure DibujarLinea3(color, direccion) {\n  Poner(color)\n  Mover(direccion)\n  Poner(color)\n  Mover(direccion)\n  Poner(color)\n }",
      expectations: [],
      test: "check_head_position: true\n\nexamples:\n - title: '¡BOOM!'\n   initial_board: |\n     GBB/1.0\n     size 3 3\n     head 0 0\n   error: wrong_argument_type")

    expect(response[:status]).to eq :passed
    expect(response[:response_type]).to eq :structured
  end

  it 'answers a valid hash when the expected boom type is unassigned_variable and the initial board is not defined' do
    response = bridge.run_tests!(
      content: "function boomBoomKid() {\n  return (unaVariableQueNoExiste)\n}",
      test: "subject: boomBoomKid\n\nshow_initial_board: false\n\nexamples:\n - error: unassigned_variable",
      expectations: [],
      extra: ""
    )

    expect(response[:status]).to eq :passed
    expect(response[:response_type]).to eq :structured
  end

  it 'answers a valid hash when the return checker has to compare a return value of True' do
    response = bridge.run_tests!(
      content: "function esLibreCostados(){\nreturn(puedeMover(Este)&&puedeMover(Oeste))\n\n}",
      test: "subject: esLibreCostados\n\nexamples:\n - initial_board: |\n     GBB/1.0\n     size 3 2\n     head 0 0\n   return: 'False'\n \n - initial_board: |\n     GBB/1.0\n     size 3 2\n     head 1 0\n   return: 'True'",
      expectations: [
        {
          binding: "esLibreCostados",
          inspection: "HasUsage:puedeMover"
        }
      ],
      extra: "",
    )

     expect(response[:status]).to eq :passed
     expect(response[:response_type]).to eq :structured
  end

  it 'answers a valid hash when the return checker has to compare a numeric value and it is defined in the test as string' do
    response = bridge.run_tests!(
      content: "function numero(){\nvalor:=cifra()\nMover(Este)\nvalor:=(valor*100)+(cifra()*10)\nMover(Este)\nvalor:=(valor+cifra())\nreturn(valor)\n}",
      test: "subject: numero\n\nexamples:\n - initial_board: |\n     GBB/1.0\n     size 3 1\n     cell 0 0 Rojo 1\n     cell 1 0 Rojo 3\n     cell 2 0 Rojo 2\n     head 0 0\n   return: '132'\n\n - initial_board: |\n     GBB/1.0\n     size 3 1\n     cell 0 0 Rojo 6\n     cell 1 0 Rojo 7\n     cell 2 0 Rojo 8\n     head 0 0\n   return: '678'",
      expectations: [
        {
          binding: "numero",
          inspection: "HasDeclaration"
        },
        {
          binding: "numero",
          inspection: "HasUsage:cifra"
        }
      ],
      extra: "function cifra() {\n  return (nroBolitas(Rojo))\n}"
    )

    expect(response[:status]).to eq :passed
    expect(response[:response_type]).to eq :structured
  end

  it 'answers a valid hash when the error checker is waiting for a wrong_arguments_quantity error' do
    response = bridge.run_tests!(
      content: "program{ \nDibujarLinea3(Verde)\n}",
      test: %q{
check_head_position: true

examples:
- initial_board: |
    GBB/1.0
    size 3 3
    head 0 0
  error: wrong_arguments_quantity
},
      expectations: [ ],
      extra: "procedure DibujarLinea3(color, direccion) {\n Poner(color)\n Mover(direccion)\n Poner(color)\n Mover(direccion)\n Poner(color)\n}"
    )

    expect(response[:status]).to eq :passed
    expect(response[:response_type]).to eq :structured
  end

  it 'answers a well formed error when the content has no program definition' do
    response = bridge.run_tests!(
      content: "",
      test: %q{
check_head_position: true

examples:
- initial_board: |
    GBB/1.0
    size 3 3
    head 0 0
  error: wrong_arguments_quantity
},
      expectations: [ ],
      extra: ""
    )

    expect(response[:status]).to eq :errored
    expect(response[:response_type]).to eq :unstructured
    expect(response[:result]).to eq "<pre>[0:0]: No program definition was found</pre>"
  end

  context 'Board rendering' do
    let(:response) {
      bridge.run_tests!(
        content: 'program {}',
        extra: '',
        test: "
check_head_position: #{check_head_position}
examples:
 - initial_board: |
     GBB/1.0
     size 4 4
     head 0 0
   final_board: |
     GBB/1.0
     size 4 4
     cell 0 0 Azul 1 Rojo 1 Verde 1 Negro 1
     head 0 0")
    }

    let(:result) {
      response[:test_results][0][:result]
    }

    context "when the test doesn't check the head's position" do
      let(:check_head_position) { false }

      it "renders the boards with the 'without-header' attribute" do
        expect(result).to include "<gs-board without-header>"
      end
    end

    context "when the test does check the head's position" do
      let(:check_head_position) { true }

      it "renders the boards without the 'without-header' attribute" do
        expect(result).not_to include "<gs-board without-header>"
      end
    end
  end

  # See https://github.com/mumuki/mulang/issues/144. Caused by not excluding the proper smells
  it 'checks an inspection over a function correctly' do
    response = bridge.run_tests!(
      {
        content: "function rojoEsDominante(){\nreturn (nroBolitas(Rojo)\u003enroBolitasTotal()-nroBolitas(Rojo))\n}",
        test: "subject: rojoEsDominante\n\nexamples:\n - initial_board: |\n     GBB/1.0\n     size 2 2\n     cell 0 0 Azul 3 Negro 2 Rojo 4 Verde 3\n     head 0 0\n   return: 'False'\n \n - initial_board: |\n     GBB/1.0\n     size 2 2\n     cell 0 0 Azul 3 Negro 2 Rojo 10 Verde 3\n     head 0 0\n   return: 'True'",
        expectations: [
          {
            binding: "rojoEsDominante",
            inspection: "HasUsage:todasMenos"
          }
        ],
        extra: "function nroBolitasTotal() {\n  return (nroBolitas(Azul) + nroBolitas(Negro) + nroBolitas(Rojo) + nroBolitas(Verde))\n}\n\nfunction todasMenos(color) {\n    return (nroBolitasTotal() - nroBolitas(color))\n}"
      }
    )
    expect(response[:status]).to eq :passed_with_warnings
    expect(response[:response_type]).to eq :structured

  end

  it 'answers a valid hash when locale is pt, with directions' do
    response = bridge.run_tests!({
        content: "program {\n  Mover(Sul); Mover(Leste)   \n}",
        test: "
        check_head_position: true
        examples:
         - initial_board: |
             GBB/1.0
             size 3 3
             head 0 2
           final_board: |
             GBB/1.0
             size 3 3
             head 1 1",
        expectations: [ ],
        locale: "pt",
        extra: "",
      })
    expect(response[:status]).to eq :passed
    expect(response[:response_type]).to eq :structured
  end

  it 'answers a valid hash when locale is pt and submission is wrong, with directions' do
    response = bridge.run_tests!({
        content: "program {\n  Mover(Sul); Mover(Leste)   \n}",
        test: "
        check_head_position: true
        examples:
         - initial_board: |
             GBB/1.0
             size 3 3
             head 0 2
           final_board: |
             GBB/1.0
             size 3 3
             head 0 0",
        expectations: [ ],
        locale: "pt",
        extra: "",
      })
    expect(response[:status]).to eq :failed
    expect(response[:response_type]).to eq :structured
  end

  it 'answers a valid hash when locale is pt, with colors' do
    response = bridge.run_tests!(
      {
        content: "program {\n  Colocar(Vermelho)    \n}",
        test: "
         examples:
         - initial_board: |
             GBB/1.0
             size 3 3
             head 0 0
           final_board: |
             GBB/1.0
             size 3 3
             cell 0 0 Rojo 1
             head 0 0",
        expectations: [ ],
        locale: "pt",
        extra: "",
      }
    )
    expect(response[:status]).to eq :passed
    expect(response[:response_type]).to eq :structured
  end


  it 'fails when locale is pt and the content of the submission is wrong' do
    response = bridge.run_tests!(
      {
        content: "program {\n  Colocar(Preto)    \n}",
        test: "
         examples:
         - initial_board: |
             GBB/1.0
             size 3 3
             head 0 0
           final_board: |
             GBB/1.0
             size 3 3
             cell 0 0 Rojo 1
             head 0 0",
        expectations: [
        ],
        locale: "pt",
        extra: "",
      }
    )
    expect(response[:status]).to eq :failed
    expect(response[:response_type]).to eq :structured
  end

  it 'responds a properly structured response when there are unexpected booms and no expected final boards' do
    response = bridge.run_tests!(
      {
        content: "
          function hayBolitasLejosAl(direccion, color, distancia) {
            MoverN(distancia, direcion)
            return (True)
          }
          ",
        test: "
          subject: hayBolitasLejosAl

          examples:
           - arguments:
             - Norte
             - Rojo
             - 2
             initial_board: |
               GBB/1.0
               size 3 3
               cell 0 2 Rojo 1
               head 0 0
             return: 'True'",
        expectations: [
        ],
        extra: "procedure MoverN(n, direccion) { repeat (n) { Mover(direccion) } }"
      }
    )

    expect(response[:response_type]).to eq :structured
    expect(response[:status]).to eq :failed
  end

  it 'can accept Blockly XML as content' do
    response = bridge.run_tests!(
      content: '<xml xmlns="http://www.w3.org/1999/xhtml"><variables></variables><block type="Program" id="xB~]3G#lp3SsK`Ys{VS^" deletable="false" x="30" y="30"><mutation timestamp="1523891789396"></mutation><statement name="program"><block type="Asignacion" id="FW1Q]83JP$a0!!$wYxyd"><field name="varName">unColor</field><value name="varValue"><block type="ColorSelector" id="l4c.8v[N.mvxPf$Zx^VW"><field name="ColorDropdown">Negro</field></block></value><next><block type="Poner" id="C1cG`0n#kyzHT5WF88~L"><value name="COLOR"><block type="variables_get" id="jv[rAEP5uKPbN{RN[.I|"><mutation var="unColor"></mutation><field name="VAR">unColor</field></block></value><next><block type="Mover" id="RqKR#pt]B~yQuOg4(u$p"><value name="DIRECCION"><block type="DireccionSelector" id="t?xv9#gqOXx$iKiVH]S;"><field name="DireccionDropdown">Norte</field></block></value></block></next></block></next></block></statement></block></xml>',
      extra: '',
      expectations: [
        {binding: 'program', inspection: 'HasUsage:unColor'},
        {binding: 'program', inspection: 'Not:HasUsage:otraCosa'}
      ],
      test: '
check_head_position: true

examples:
 - initial_board: |
     GBB/1.0
     size 4 4
     head 0 0
   final_board: |
     GBB/1.0
     size 4 4
     cell 0 0 Azul 0 Rojo 0 Verde 0 Negro 1
     head 0 1
    ')

    expect(response.except(:test_results)).to eq response_type: :structured,
                                                 status: :passed,
                                                 feedback: '',
                                                 expectation_results: [
                                                   {binding: "program", inspection: "Uses:=unColor", result: :passed},
                                                   {binding: "program", inspection: "Not:Uses:=otraCosa", result: :passed}
                                                 ],
                                                 result: ''
  end

  it 'can accept Blockly XML as extra AND content, using primitive actions' do
    response = bridge.run_tests!(
      content: '<xml xmlns="http://www.w3.org/1999/xhtml"><variables></variables><block type="Program" id="PuD+$,0HT^k)5IUPdU!?" deletable="false" x="150" y="-160"><mutation timestamp="1523892212925"></mutation><statement name="program"><block type="RepeticionSimple" id="YeG}Q75;8ra*Wp3:EU2q"><value name="count"><block type="dobleDe_" id="3/`k,b:TE+S9Y9qKDX~p"><value name="arg1"><block type="math_number" id="[op/fExN+uq4:U]0NqoH"><field name="NUM">3</field></block></value></block></value><statement name="block"><block type="PonerTres_" id="MGSh1,-~Pi}EJ7{pZ;mX"><value name="arg1"><block type="ColorSelector" id="veM!Uyw2$}S=hJtas!Cs"><field name="ColorDropdown">Azul</field></block></value></block></statement></block></statement></block></xml>',
      extra: '<xml xmlns="http://www.w3.org/1999/xhtml"><variables></variables><block type="procedures_defnoreturn" id="h#T:7OUn=gaPXqUplXe]" x="80" y="-207"><mutation><arg name="color"></arg></mutation><field name="NAME">PonerTres_</field><field name="ARG0">color</field><statement name="STACK"><block type="Poner" id="YcB^xSAiU-+sa4[z8wKO"><value name="COLOR"><block type="variables_get" id="rsm([Dp*s5Hi+*bWE}*i"><mutation var="color" parent="h#T:7OUn=gaPXqUplXe]"></mutation></block></value><next><block type="Poner" id="jGqg=|!OChe?VZ0_dsUd"><value name="COLOR"><block type="variables_get" id="RawKnPa#tN{0vEvMFmY_"><mutation var="color" parent="h#T:7OUn=gaPXqUplXe]"></mutation></block></value><next><block type="Poner" id="BnYamcc*iwjGM,-yoa}n"><value name="COLOR"><block type="variables_get" id="z#LO[/(O-spS=WQVeh)*"><mutation var="color" parent="h#T:7OUn=gaPXqUplXe]"></mutation></block></value></block></next></block></next></block></statement></block><block type="procedures_defreturnsimplewithparams" id=")(t47XNXCjl]b^(zV:4;" x="80" y="-8"><mutation statements="false"><arg name="número"></arg></mutation><field name="NAME">dobleDe_</field><field name="ARG0">número</field><value name="RETURN"><block type="OperadorNumerico" id=":}n%C$e}/%y;JdE1]`D("><field name="OPERATOR">*</field><value name="arg1"><block type="variables_get" id="h6)YVE)7%.KldhC)wE$~"><mutation var="número" parent=")(t47XNXCjl]b^(zV:4;"></mutation></block></value><value name="arg2"><block type="math_number" id="EB$._vZ}Qk+wIYcE:V74"><field name="NUM">2</field></block></value></block></value></block></xml>',
      expectations: [
        {binding: 'program', inspection: 'Uses:dobleDe_'},
        {binding: 'program', inspection: 'Uses:PonerTres_'}
      ],
      test: '
check_head_position: true

examples:
 - initial_board: |
     GBB/1.0
     size 4 4
     head 0 0
   final_board: |
     GBB/1.0
     size 4 4
     cell 0 0 Azul 18 Rojo 0 Verde 0 Negro 0
     head 0 0
    ')

    expect(response.except(:test_results)).to eq response_type: :structured,
                                                 status: :passed,
                                                 feedback: '',
                                                 expectation_results: [
                                                   {binding: "program", inspection: "Uses:dobleDe_", result: :passed},
                                                   {binding: "program", inspection: "Uses:PonerTres_", result: :passed}
                                                 ],
                                                 result: ''
  end

  context 'Blockly XML with finer expectations' do
    let(:expectations) { [
      {binding: '*', inspection: 'Uses:RecolectarPolen'},
      {binding: '*', inspection: 'Declares:RecolectarPolen'},
      {binding: 'RecolectarPolen', inspection: 'UsesRepeat'}
    ] }

    def run_expectations!(content)
      extra = '<xml xmlns="http://www.w3.org/1999/xhtml"><variables><variable type="" id="#tkEaZ|1O/iYzpk$jb*F">direccion</variable></variables><block type="procedures_defnoreturn" id="ta2r.#tE.Z3=cqo_~(GS" x="42" y="-63"><mutation><arg name="direccion"></arg></mutation><field name="NAME">Volar Al_</field><field name="ARG0">direccion</field><statement name="STACK"><block type="Sacar" id="5*l*j7d[{}-sxylSK?yc"><value name="COLOR"><block type="ColorSelector" id="k]:7DyS5cSE%dt-#;N~8"><field name="ColorDropdown">Negro</field></block></value><next><block type="Mover" id="Ld#c~6FG8LB)y94=iHi("><value name="DIRECCION"><block type="variables_get" id="ea,RDtzQN,XRBgfNU5AU"><mutation var="direccion" parent="ta2r.#tE.Z3=cqo_~(GS"></mutation></block></value><next><block type="Poner" id="+HbxwbY6f-b.ZL/fNm%j"><value name="COLOR"><block type="ColorSelector" id="ZjyHOJAVte5Tlt:L`%oO"><field name="ColorDropdown">Negro</field></block></value></block></next></block></next></block></statement></block></xml>'
      bridge.run_tests!(
        content: content,
        extra: extra,
        expectations: expectations,
        test: '
  check_head_position: true

  examples:
  - initial_board: |
      GBB/1.0
      size 4 4
      head 0 0
    final_board: |
      GBB/1.0
      size 4 4
      cell 0 0 Azul 18 Rojo 0 Verde 0 Negro 0
      head 0 0
      ')[:expectation_results]
    end

    it 'works when all pass' do
      # Equivalent to program { VolarAl_(Este) ; RecolectarPolen() } procedure RecolectarPolen() { repeat(5) { Sacar(Verde) } }
      content = '<xml xmlns="http://www.w3.org/1999/xhtml"><variables><variable type="" id="#tkEaZ|1O/iYzpk$jb*F">direccion</variable></variables><block type="Program" id="Rp8VMHPa/]EZ}FvH/Pi|" deletable="false" x="42" y="-98"><mutation timestamp="1528058851731"></mutation><statement name="program"><block type="VolarAl_" id="`I4gt4t#Rj|OB3QwE2HP"><value name="arg1"><block type="DireccionSelector" id="7A8Ipt/$RClcH5KNEZ)^"><field name="DireccionDropdown">Este</field></block></value><next><block type="procedures_callnoreturnnoparams" id="31;^FQ_kr`XO|9D9`y|1"><mutation name="Recolectar Polen"></mutation></block></next></block></statement></block><block type="procedures_defnoreturnnoparams" id="9)jdRaCNSwCopGPcG^6w" x="40" y="112"><field name="NAME">Recolectar Polen</field><statement name="STACK"><block type="RepeticionSimple" id=";q2M8~vOaO_Qo~#Qxz#Z"><value name="count"><block type="math_number" id="6o]|L|{7Xh|#+p2VnYn("><field name="NUM">5</field></block></value><statement name="block"><block type="Sacar" id="8{aYL%2e+he~ztS%MlZ$"><value name="COLOR"><block type="ColorSelector" id="(VW][LR1vg)z*2!r,{kG"><field name="ColorDropdown">Verde</field></block></value></block></statement></block></statement></block></xml>'
      expect(run_expectations! content).to eq [{binding: '*', inspection: "Uses:RecolectarPolen", result: :passed},
                                               {binding: '*', inspection: "Declares:RecolectarPolen", result: :passed},
                                               {binding: 'RecolectarPolen', inspection: "UsesRepeat", result: :passed}]
    end

    it 'works when all expectations fail' do
      # Equivalent to program { VolarAl_(Este) ; repeat(5) { Sacar(Verde) } }
      content = '<xml xmlns="http://www.w3.org/1999/xhtml"><variables><variable type="" id="#tkEaZ|1O/iYzpk$jb*F">direccion</variable></variables><block type="Program" id="Rp8VMHPa/]EZ}FvH/Pi|" deletable="false" x="42" y="-98"><mutation timestamp="1528054201699"></mutation><statement name="program"><block type="VolarAl_" id="`I4gt4t#Rj|OB3QwE2HP"><value name="arg1"><block type="DireccionSelector" id="7A8Ipt/$RClcH5KNEZ)^"><field name="DireccionDropdown">Este</field></block></value><next><block type="RepeticionSimple" id=";q2M8~vOaO_Qo~#Qxz#Z"><value name="count"><block type="math_number" id="6o]|L|{7Xh|#+p2VnYn("><field name="NUM">5</field></block></value><statement name="block"><block type="Sacar" id="8{aYL%2e+he~ztS%MlZ$"><value name="COLOR"><block type="ColorSelector" id="(VW][LR1vg)z*2!r,{kG"><field name="ColorDropdown">Verde</field></block></value></block></statement></block></next></block></statement></block></xml>'
      expect(run_expectations! content).to eq [{binding: '*', inspection: "Uses:RecolectarPolen", result: :failed},
                                               {binding: '*', inspection: "Declares:RecolectarPolen", result: :failed},
                                               {binding: 'RecolectarPolen', inspection: "UsesRepeat", result: :failed}]
    end

    it 'works when some fail with empty blocks' do
      # Equivalent to program { VolarAl_(Este) ; repeat(5) { Sacar(Verde) } } procedure HacerAlgo() { }
      content = '<xml xmlns="http://www.w3.org/1999/xhtml"><variables><variable type="" id="#tkEaZ|1O/iYzpk$jb*F">direccion</variable></variables><block type="Program" id="Rp8VMHPa/]EZ}FvH/Pi|" deletable="false" x="42" y="-98"><mutation timestamp="1528058068163"></mutation><statement name="program"><block type="VolarAl_" id="`I4gt4t#Rj|OB3QwE2HP"><value name="arg1"><block type="DireccionSelector" id="7A8Ipt/$RClcH5KNEZ)^"><field name="DireccionDropdown">Este</field></block></value><next><block type="RepeticionSimple" id=";q2M8~vOaO_Qo~#Qxz#Z"><value name="count"><block type="math_number" id="6o]|L|{7Xh|#+p2VnYn("><field name="NUM">5</field></block></value><statement name="block"><block type="Sacar" id="8{aYL%2e+he~ztS%MlZ$"><value name="COLOR"><block type="ColorSelector" id="(VW][LR1vg)z*2!r,{kG"><field name="ColorDropdown">Verde</field></block></value></block></statement></block></next></block></statement></block><block type="procedures_defnoreturnnoparams" id="9)jdRaCNSwCopGPcG^6w" x="40" y="112"><field name="NAME">Hacer algo</field></block></xml>'
      expect(run_expectations! content).to eq [{binding: '*', inspection: "Uses:RecolectarPolen", result: :failed},
                                               {binding: '*', inspection: "Declares:RecolectarPolen", result: :failed},
                                               {binding: 'RecolectarPolen', inspection: "UsesRepeat", result: :failed}]
    end


    it 'works when some fail because of similar names' do
      # Equivalent to program { VolarAl_(Este) ; RecolectarPolenta() } procedure RecolectarPolenta() { repeat(5) { Sacar(Verde) } }
      content = '<xml xmlns="http://www.w3.org/1999/xhtml"><variables><variable type="" id="#tkEaZ|1O/iYzpk$jb*F">direccion</variable></variables><block type="Program" id="Rp8VMHPa/]EZ}FvH/Pi|" deletable="false" x="42" y="-98"><mutation timestamp="1528058279725"></mutation><statement name="program"><block type="VolarAl_" id="`I4gt4t#Rj|OB3QwE2HP"><value name="arg1"><block type="DireccionSelector" id="7A8Ipt/$RClcH5KNEZ)^"><field name="DireccionDropdown">Este</field></block></value><next><block type="procedures_callnoreturnnoparams" id="31;^FQ_kr`XO|9D9`y|1"><mutation name="Recolectar Polenta"></mutation></block></next></block></statement></block><block type="procedures_defnoreturnnoparams" id="9)jdRaCNSwCopGPcG^6w" x="40" y="112"><field name="NAME">Recolectar Polenta</field><statement name="STACK"><block type="RepeticionSimple" id=";q2M8~vOaO_Qo~#Qxz#Z"><value name="count"><block type="math_number" id="6o]|L|{7Xh|#+p2VnYn("><field name="NUM">5</field></block></value><statement name="block"><block type="Sacar" id="8{aYL%2e+he~ztS%MlZ$"><value name="COLOR"><block type="ColorSelector" id="(VW][LR1vg)z*2!r,{kG"><field name="ColorDropdown">Verde</field></block></value></block></statement></block></statement></block></xml>'
      expect(run_expectations! content).to eq [{binding: '*', inspection: "Uses:RecolectarPolen", result: :failed},
                                               {binding: '*', inspection: "Declares:RecolectarPolen", result: :failed},
                                               {binding: 'RecolectarPolen', inspection: "UsesRepeat", result: :failed}]
    end

    it 'doesn\'t run tests in interactive mode' do
      response = bridge.run_tests!(
        {
          content: "function rojoEsDominante(){\nreturn (nroBolitas(Rojo)\u003enroBolitasTotal()-nroBolitas(Rojo))\n}",
          test: "subject: rojoEsDominante\n\ninteractive: true\n\nexamples:\n - initial_board: |\n     GBB/1.0\n     size 2 2\n     cell 0 0 Azul 3 Negro 2 Rojo 4 Verde 3\n     head 0 0\n   return: 'False'\n \n - initial_board: |\n     GBB/1.0\n     size 2 2\n     cell 0 0 Azul 3 Negro 2 Rojo 10 Verde 3\n     head 0 0\n   return: 'False'",
          expectations: [
            {
              binding: "rojoEsDominante",
              inspection: "HasUsage:todasMenos"
            }
          ],
          extra: "function nroBolitasTotal() {\n  return (nroBolitas(Azul) + nroBolitas(Negro) + nroBolitas(Rojo) + nroBolitas(Verde))\n}\n\nfunction todasMenos(color) {\n    return (nroBolitasTotal() - nroBolitas(color))\n}"
        }
      )
      expect(response[:status]).to eq :passed_with_warnings
      expect(response[:response_type]).to eq :unstructured
    end
  end
end
