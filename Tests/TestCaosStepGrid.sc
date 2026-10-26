// CaosBox v2.3.0 - Tests for the step grid geometry
//
// La geometria de la rejilla vive en metodos de clase (sin Qt), asi que se
// puede probar headless: ancho de celda, posicion, gaps de grupo y hit-testing.

TestCaosStepGrid : UnitTest {

	classvar <width = 889;
	classvar <height = 20;

	test_groupCount {

		this.assertEquals(CaosStepGrid.groupCount(32), 7,
			"32 pasos en grupos de 4 dejan 7 separadores");

		this.assertEquals(CaosStepGrid.groupCount(4), 0);
		this.assertEquals(CaosStepGrid.groupCount(8), 1);

	}

	test_cellWidthFitsTheWidth {

		var cellW = CaosStepGrid.cellWidth(width);
		var last = CaosStepGrid.cellRect(31, width, height);

		this.assert(cellW > 0, "la celda tiene ancho positivo");
		this.assert(last.right <= (width - 1), "la ultima celda entra en la vista");

	}

	test_cellRectUsesTheRowHeight {

		var rect = CaosStepGrid.cellRect(0, width, height);

		this.assertEquals(rect.top, 3);
		this.assertEquals(rect.height, height - 6);

	}

	test_groupGapIsBiggerThanTheCellGap {

		var r3 = CaosStepGrid.cellRect(3, width, height);
		var r4 = CaosStepGrid.cellRect(4, width, height);

		this.assertEquals((r4.left - r3.right), 9,
			"gap de celda (3) + gap de grupo (6)");

	}

	test_indexAtHitsTheFirstAndLastCells {

		var first = CaosStepGrid.cellRect(0, width, height);
		var last = CaosStepGrid.cellRect(31, width, height);

		this.assertEquals(CaosStepGrid.indexAt(first.center.x, width), 0);
		this.assertEquals(CaosStepGrid.indexAt(last.center.x, width), 31);

	}

	test_indexAtMissesMarginsAndGaps {

		var first = CaosStepGrid.cellRect(0, width, height);

		this.assertEquals(CaosStepGrid.indexAt(0, width), nil, "margen izquierdo");
		this.assertEquals(CaosStepGrid.indexAt(width - 0.5, width), nil, "margen derecho");
		this.assertEquals(CaosStepGrid.indexAt(first.right + 1, width), nil,
			"el hueco entre celdas no pinta");

	}

}
