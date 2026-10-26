////////////////////////////////////
// MIDI connection — M-Audio Xsession Pro
////////////////////////////////////
(
var specs;

MIDIIn.connectAll;

~cbox_midi_funcs = List.new;

// helper: nodo + fader + numbox
~cbox_midi_apply = {|nodeGetter, key, map, faderGetter, numGetter, faderMap, val|
	var mapped = map.value(val);
	var faderVal = if(faderMap.notNil, { faderMap.value(val) }, { val / 127 });

	nodeGetter.value !? {|node| node.set(key, mapped) };
	{
		faderGetter.value !? {|fader| fader.value_(faderVal) };
		numGetter.value !? {|num| num.value_(mapped) };
	}.defer;
};

// [CC, nodo, parámetro, espec, fader, numbox, faderMap (opcional)]
specs = [
	[12, { ~cbox_mast },       \vol,              {|v| v.linlin(0,127,0,1) },    { ~cbox_mastfader },     { ~cbox_num },      nil],
	[26, { ~cbox_mast },       \below,            {|v| v.linlin(0,127,0.01,1) }, { ~cbox_mastfader2 },    { ~cbox_num2 },     nil],
	[25, { ~cbox_mast },       \relaxTime,        {|v| v.linlin(0,127,0.01,1) }, { ~cbox_mastfader3 },    { ~cbox_num3 },     nil],
	[24, { ~cbox_mast },       \limit,            {|v| v.linlin(0,127,0.01,1) }, { ~cbox_mastfader4 },    { ~cbox_num4 },     nil],
	[29, { ~cbox_mastrev },    \mix,              {|v| v.linlin(0,127,0.01,1) }, { ~cbox_auxrfader },     { ~cbox_numr },     nil],
	[28, { ~cbox_mastrev },    \room,             {|v| v.linlin(0,127,0.01,1.3)}, { ~cbox_auxroomfader }, { ~cbox_numroom }, nil],
	[27, { ~cbox_mastrev },    \damp,             {|v| v.linlin(0,127,1,0.01) }, { ~cbox_auxdfader },    { ~cbox_numd },     {|v| 1 - (v/127)}],
	[11, { ~cbox_mastdel },    \deltime,          {|v| v.linlin(0,127,0,1) },    { ~cbox_auxtfader },     { ~cbox_numt },     nil],
	[14, { ~cbox_mastdel },    \delfeed,          {|v| v.linlin(0,127,0,1) },    { ~cbox_auxffader },     { ~cbox_numf },     nil],
	[36, { ~cbox_mastpit },    \pitch,            {|v| v.linlin(0,127,0.01,4) }, { ~cbox_auxpfader },     { ~cbox_nump },     nil],
	[35, { ~cbox_mastpit },    \pitchDispersion,  {|v| v.linlin(0,127,0.01,1) }, { ~cbox_auxpdfader },    { ~cbox_numpd },    nil],
	[34, { ~cbox_mastpit },    \timeDispersion,   {|v| v.linlin(0,127,0.01,1) }, { ~cbox_auxtdfader },    { ~cbox_numtd },    nil],
	[33, { ~cbox_mastlowf },   \cutfreq,          {|v| v.linexp(0,127,20,20000)},{ ~cbox_lowcfader },     { ~cbox_numf1 },    nil],
	[32, { ~cbox_mastbandf },  \cutfreq,          {|v| v.linexp(0,127,20,20000)},{ ~cbox_bandcfader },    { ~cbox_numf5 },    nil],
	[31, { ~cbox_masthighf },  \cutfreq,          {|v| v.linexp(0,127,20,20000)},{ ~cbox_highcfader },    { ~cbox_numf3 },    nil]
];

specs.do {|row|
	~cbox_midi_funcs.add(
		MIDIFunc.cc({|val|
			~cbox_midi_apply.value(row[1], row[2], row[3], row[4], row[5], row[6], val);
		}, row[0])
	);
};

// granulador: CC20 trigger, CC17 size, CC15 reverse
~cbox_midi_funcs.add(MIDIFunc.cc({|val|
	~cbox_grains !? {|grain| grain.set(\trigger, val.linlin(0,127,0.1,8)) };
	{ ~cbox_gfaders !? {|fader| fader.x_(val/127) } }.defer;
}, 20));

~cbox_midi_funcs.add(MIDIFunc.cc({|val|
	~cbox_grains !? {|grain| grain.set(\size, val.linlin(0,127,1,0.01)) };
	{ ~cbox_gfaders !? {|fader| fader.y_(val/127) } }.defer;
}, 17));

~cbox_midi_funcs.add(MIDIFunc.cc({|val|
	var size = val.linlin(0,127,-1,-0.01);
	~cbox_grains !? {|grain| grain.set(\size, size, \trigger, size) };
	{ ~cbox_gfaders !? {|fader| fader.y_(val/127); fader.x_(val/127) } }.defer;
}, 15));

// liberar el mapeo (por ejemplo al cerrar CaosBox)
~cbox_midi_free = {
	~cbox_midi_funcs !? {|funcs| funcs.do(_.free) };
	~cbox_midi_funcs = nil;
	"CaosBox: MIDI mapping freed".postln;
};
)
