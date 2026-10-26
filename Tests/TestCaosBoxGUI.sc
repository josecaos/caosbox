// CaosBox v2.3.0 - Tests for the GUI registry and palette
//
// Headless: no widgets, no server. Se prueba la paleta y el contrato de
// CaosBox.gui (color por Color, simbolo o array).

TestCaosBoxGUI : UnitTest {

	var <gui;

	setUp {

		gui = CaosBoxGUI.new;

	}

	test_defaults {

		this.assertEquals(gui.accent, CaosBoxGUI.colorAliases[\green],
			"el acento por defecto es el verde de la familia");

		this.assert(gui.stepGrids.isEmpty, "sin step grids registrados");
		this.assert(gui.background.notNil);
		this.assertEquals(gui.playheadColor, gui.accent.blend(Color.white, 0.7));

	}

	test_colorWithSymbol {

		gui.color(\red);

		this.assertEquals(gui.accent, CaosBoxGUI.colorAliases[\red]);

	}

	test_colorWithColor {

		gui.color(Color(0.1, 0.2, 0.3));

		this.assertEquals(gui.accent.asArray, [0.1, 0.2, 0.3, 1.0]);

	}

	test_colorWithArray {

		gui.color([0.4, 0.5, 0.6]);

		this.assertEquals(gui.accent.asArray, [0.4, 0.5, 0.6, 1.0]);

	}

	test_unknownColorKeepsTheAccent {

		var before = gui.accent;

		gui.color(\notAColor);

		this.assertEquals(gui.accent, before, "un color invalido no rompe la vista");

	}

	test_playheadColorFollowsTheAccent {

		gui.color(\orange);

		this.assertEquals(gui.playheadColor,
			CaosBoxGUI.colorAliases[\orange].blend(Color.white, 0.7));

	}

	test_caosBoxGuiIsTheSameRegistry {

		this.assert(CaosBox.gui === CaosBox.gui,
			"CaosBox.gui devuelve siempre el mismo registro");

	}

}
