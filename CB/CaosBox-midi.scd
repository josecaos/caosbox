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
	// right-hand knobs 1/2/3, top to bottom: LPF, HPF, BPF
	[31, { ~cbox_mastlowf },   \cutfreq,          {|v| v.linexp(0,127,20,20000)},{ ~cbox_lowcfader },     { ~cbox_numf1 },    nil],
	[32, { ~cbox_masthighf },  \cutfreq,          {|v| v.linexp(0,127,20,20000)},{ ~cbox_highcfader },    { ~cbox_numf3 },    nil],
	[33, { ~cbox_mastbandf },  \cutfreq,          {|v| v.linexp(0,127,20,20000)},{ ~cbox_bandcfader },    { ~cbox_numf5 },    nil]
];

specs.do {|row|
	~cbox_midi_funcs.add(
		MIDIFunc.cc({|val|
			~cbox_midi_apply.value(row[1], row[2], row[3], row[4], row[5], row[6], val);
		}, row[0])
	);
};

// granulador: crossfader = X (trigger), right pitch fader CC15 = Y (size).
// The crossfader sends CC17 (normal) and CC20 (inverted); both normalize to
// the same physical position, so either message can drive X.
~cbox_midi_grain_x = {|val|
	var norm = val / 127;
	var spec = ~cbox_gtparam ? ControlSpec(4, 32, \lin, 1, 4);
	~cbox_grains !? {|grain| grain.set(\trigger, spec.map(norm)) };
	{ ~cbox_gfaders !? {|fader| fader.x_(norm) } }.defer;
};

~cbox_midi_grain_y = {|val|
	var norm = val / 127;
	var spec = ~cbox_gsparam ? ControlSpec(0.01, 0.05, \lin, 0.001, 0.05);
	~cbox_grains !? {|grain| grain.set(\size, spec.map(norm)) };
	{ ~cbox_gfaders !? {|fader| fader.y_(norm) } }.defer;
};

~cbox_midi_funcs.add(MIDIFunc.cc({|val| ~cbox_midi_grain_x.value(val) }, 17));
~cbox_midi_funcs.add(MIDIFunc.cc({|val| ~cbox_midi_grain_x.value(127 - val) }, 20));
~cbox_midi_funcs.add(MIDIFunc.cc({|val| ~cbox_midi_grain_y.value(val) }, 15));

// liberar el mapeo (por ejemplo al cerrar CaosBox)
~cbox_midi_free = {
	~cbox_midi_funcs !? {|funcs| funcs.do(_.free) };
	~cbox_midi_funcs = nil;
	"CaosBox: MIDI mapping freed".postln;
};
)
